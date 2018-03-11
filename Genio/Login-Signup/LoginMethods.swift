//
//  LoginMethods.swift
//  Genio
//
//  Created by Luigi Pepe on 3/11/18.
//  Copyright © 2018 Luigi Pepe. All rights reserved.
//

import Foundation
import UIKit


/******************************************************************************************/
extension LoginViewController {
    
    //#MARK: login
    func checkEmailAndPsw(sender: UIButton) {
        
        //start animating loading wheel
        DispatchQueue.main.async {
            self.activity_indicator_.startAnimating()
        }
        
        //get local variables of email and psw
        guard let insertedEmail = self.email_text_field_.text else { return }
        guard let insertedPassword = self.psw_text_field_.text else { return }
        let trimmedEmail = insertedEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        //get API url to check if email is valid
        var baseURL = UserDefaults.standard.string(forKey: "myURL")!
        baseURL = baseURL + "register/exists/" + trimmedEmail
        
        let stringReq = NSURL(string: baseURL)
        let request = NSMutableURLRequest(url: stringReq! as URL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        httpRequest(request: request) {
            (data, error, response) -> Void in
            if error != nil {
                print(error)
                DispatchQueue.main.async {
                    self.activity_indicator_.stopAnimating()
                    let alert = errorHandling(response: response)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                var jsonObject: Dictionary<String, AnyObject>?
                do {
                    jsonObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String,AnyObject>
                } catch {
                    DispatchQueue.main.async { self.errorAlert(message: "An error occurred") }
                }
                if let message = jsonObject?["message"] as? String {
                    print("####", message)
                    if message == "NOT_PRESENT" {
                        DispatchQueue.main.async { self.errorAlert(message: "Email or Username do not exist") }
                    } else {
                        let lengthPsw = isPswLenth(password: insertedPassword)
                        if lengthPsw == true {
                            self.logIn(insertedEmail: insertedEmail, insertedPassword: insertedPassword, sender: sender)
                        } else {
                            DispatchQueue.main.async { self.errorAlert(message: "Password is not valid") }
                        }
                    }
                }
            }
        }
    }
    
    func errorAlert(message: String, title: String = "Login Error") {
        self.activity_indicator_.stopAnimating()
        let alert = createAlert(title: title, message: message)
        self.present(alert, animated: true, completion: nil)
    }
    
    func logIn(insertedEmail: String, insertedPassword: String, sender: UIButton) {
        
        // try authentication with email and psw
        let request = logInRequest(insertedEmail: insertedEmail, insertedPassword: insertedPassword)
        httpRequest(request: request){
            (data, error, response) -> Void in
            
            if error != nil {
                DispatchQueue.main.async {
                    let alert = errorHandling(response: response)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                
                var jsonObject: Dictionary<String, AnyObject>?
                do {
                    jsonObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String,AnyObject>
                } catch {
                    DispatchQueue.main.async { self.errorAlert(message: "An error occurred") }
                }
                guard let myJSONObject = jsonObject else {
                    return
                }
                print(myJSONObject)
                
                let status = myJSONObject["status"] as! String
                print("status ", status)
                if status == "ok" {
                    
                    let token  = myJSONObject["token"] as! String
                    UserDefaults.standard.set(token, forKey: "token")
                    UserDefaults.standard.set(insertedPassword, forKey: "psw")
                    
                    if isValidEmail(testStr: insertedEmail) {
                        UserDefaults.standard.set(insertedEmail, forKey: "email")
                    } else {
                        UserDefaults.standard.set(insertedEmail, forKey: "userName")
                    }
                    self.token = token
                    DispatchQueue.main.async {
                        self.activity_indicator_.stopAnimating()
                        self.performSegue(withIdentifier: "goToMyProfile", sender: sender)
                    }
                } else {
                    
                    let message = myJSONObject["message"] as! String
                    if message == "Token in blacklist" {
                        askToken() {
                            (message) -> Void in                            
                            if message == "ok" {
                                self.logIn(insertedEmail: insertedEmail, insertedPassword: insertedPassword, sender: sender)
                            } else {
                                DispatchQueue.main.async { self.errorAlert(message: "Authentification failed", title: "Error") }
                            }
                        }
                    } else {
                        DispatchQueue.main.async { self.errorAlert(message: "Authentification failed", title: "Error") }
                    }
                }
            }
        }
    }
}
/******************************************************************************************/
