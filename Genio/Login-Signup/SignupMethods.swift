//
//  SignupMethods.swift
//  Genio
//
//  Created by Luigi Pepe on 3/29/18.
//  Copyright © 2018 Luigi Pepe. All rights reserved.
//

import Foundation
import UIKit
/******************************************************************************************/
extension SignupViewController {

    func checkSignupFields() {
        
        guard let insertedUserName = self.usernameTextField.text else { return }
        guard let insertedFullName = self.fullnameTextField.text else { return }
        guard let insertedEmail = self.emailTextField.text else { return /*handle error*/}
        guard let insertedPassword = self.passwordTextField.text else { return /*handle error*/}
        guard let confirmationPassword = self.confirmpasswordTextField.text else { return /*handle error*/}
        
        DispatchQueue.main.async {
            self.fullnameTextField.isEnabled = false
            self.usernameTextField.isEnabled = false
            self.passwordTextField.isEnabled = false
            self.confirmpasswordTextField.isEnabled = false
            self.activity_indicator.startAnimating()
            self.profile_image_view_.gestureRecognizers?.removeAll()
        }
        
        var baseURL = UserDefaults.standard.string(forKey: "myURL")!
        baseURL = baseURL + "register/exists/" + insertedUserName
        
        let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        httpRequest(request: request) {
            (data, error, response) -> Void in
            if error != nil {
                DispatchQueue.main.async {
                    let alert = errorHandling(response: response)
                    self.present(alert, animated: true, completion: nil)
                    self.repristinateView()
                }
            } else {
                var jsonObject: Dictionary<String, AnyObject>?
                
                do {
                    jsonObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String,AnyObject>
                } catch {
                    DispatchQueue.main.async {
                        self.repristinateView()
                        let alert = createAlert(title: "Sign Up Error", message: "An error occurred")
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                if let message = jsonObject?["message"] as? String {
                    if message == "NOT_PRESENT" {   //user name is good
                        var baseURL2 = UserDefaults.standard.string(forKey: "myURL")!
                        baseURL2 = baseURL2 + "register/exists/" + insertedEmail
                        
                        let request2 = NSMutableURLRequest(url: NSURL(string: baseURL2)! as URL)
                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                        request.httpMethod = "GET"
                        
                        httpRequest(request: request2) {
                            (data, error, response) -> Void in
                            
                            if error == nil {
                                
                                var jsonObject2: Dictionary<String, AnyObject>?
                                do {
                                    jsonObject2 = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String,AnyObject>
                                } catch {
                                    DispatchQueue.main.async {
                                        self.repristinateView()
                                        let alert = createAlert(title: "Sign Up Error", message: "An error occurred")
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                                
                                if let message2 = jsonObject2?["message"] as? String {
                                    if message2 == "NOT_PRESENT" {  // email is good
                                        
                                        let validEmail = isValidEmail(testStr: insertedEmail)
                                        let lengthPsw = isPswLenth(password: insertedPassword)
                                        let validPsw = isPswSame(password: insertedPassword, confirmPassword: confirmationPassword)
                                        if validEmail && lengthPsw && validPsw {
                                            
                                            let fbID = UserDefaults.standard.string(forKey: "fbID")
                                            DispatchQueue.main.async {
                                                guard signUpRequest(instertedUserName: insertedUserName, insertedEmail: insertedEmail, insertedPassword: insertedPassword, insertedFullName: insertedFullName, profileImage: self.profile_image_view_.image, facebookID: fbID, iOSDeviceToken: nil) != nil else {
                                                    return
                                                }
                                            }
                                            
                                            httpRequest(request: request){
                                                (data, error, response) -> Void in
                                                
                                                let httpResponse = response as? HTTPURLResponse
                                                print(response as Any)
                                                print((httpResponse?.statusCode)!)
                                                
                                                var jsonObject: Dictionary<String, AnyObject>?
                                                do {
                                                    jsonObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String,AnyObject>
                                                } catch {
                                                    DispatchQueue.main.async {
                                                        self.repristinateView()
                                                        let alert = createAlert(title: "Sign Up Error", message: "An error occurred")
                                                        self.present(alert, animated: true, completion: nil)
                                                    }
                                                }
                                                
                                                print(jsonObject ?? 0)
                                                if error != nil  || data == nil || (httpResponse?.statusCode)! >= 400 || (httpResponse?.statusCode)! < 200  {
                                                    let alert = createAlert(title: "Sign Up Error", message: "An Error Occurred")
                                                    self.present(alert, animated: true, completion: nil)
                                                } else {
                                                    DispatchQueue.main.async {
                                                        let alert = createAlert(title: "Complete Sign Up", message: "Please check your email and follow instructions to complete your registration")
                                                        self.present(alert, animated: true, completion: nil)
                                                    }
                                                }
                                            }
                                        } else {
                                            
                                            if insertedPassword == "" || insertedEmail == "" || insertedUserName == ""{
                                                
                                                let alert = createAlert(title: "Sign Up Error", message: "Please enter UserName, Email and Password")
                                                self.present(alert, animated: true, completion: nil)
                                            } else if validEmail == false {
                                                
                                                let alert = createAlert(title: "Sign Up Error", message: "Please enter a valid Email address")
                                                self.present(alert, animated: true, completion: nil)
                                            } else if lengthPsw == false {
                                                
                                                let alert = createAlert(title: "Sign Up Error", message: "Password must have at least 8 carachters")
                                                self.present(alert, animated: true, completion: nil)
                                            } else {
                                                
                                                let alert = createAlert(title: "Sign Up Error", message: "Wrong confirmation Password")
                                                self.present(alert, animated: true, completion: nil)
                                            }
                                            
                                            self.repristinateView()
                                            let tapProfilePic: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectProfilePic))
                                            DispatchQueue.main.async {
                                                self.profile_image_view_.addGestureRecognizer(tapProfilePic)
                                            }
                                        }
                                    } else {
                                        
                                        self.repristinateView()
                                        let tapProfilePic: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectProfilePic))
                                        DispatchQueue.main.async {
                                            self.profile_image_view_.addGestureRecognizer(tapProfilePic)
                                            let alert = createAlert(title: "Error", message: "Your Email already exists")
                                            self.present(alert, animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        self.repristinateView()
                        let tapProfilePic: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectProfilePic))
                        DispatchQueue.main.async {
                            self.profile_image_view_.addGestureRecognizer(tapProfilePic)
                            let alert = createAlert(title: "Error", message: "Your Username already exists")
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    /********************************************************************************/
    func repristinateView(){
        DispatchQueue.main.async {
            self.emailTextField.isEnabled = true
            self.fullnameTextField.isEnabled = true
            self.usernameTextField.isEnabled = true
            self.passwordTextField.isEnabled = true
            self.confirmpasswordTextField.isEnabled = true
            self.activity_indicator.stopAnimating()
        }
    }
    /********************************************************************************/
        
    //#MARK: Actions
    
    /********************************************************************************/
    @objc func selectProfilePic() {
        
        let actionController = UIAlertController(title: "Photo", message: nil, preferredStyle: .actionSheet)
        let newPhotoAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action  in  self.accessLibrary()  } )
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action  in  self.accessCamera()  } )
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionController.addAction(newPhotoAction)
        actionController.addAction(cameraAction)
        actionController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(actionController, animated: true, completion: nil)
        }
    }
    /********************************************************************************/
    
    /********************************************************************************/
    func accessLibrary() {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        picker.delegate = self
        picker.modalPresentationStyle = .overCurrentContext
        DispatchQueue.main.async {
            self.present(picker, animated: true, completion: nil)
        }
    }
    /********************************************************************************/
    
    
    /********************************************************************************/
    func accessCamera() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = false
        picker.modalPresentationStyle = .overCurrentContext
        DispatchQueue.main.async {
            self.present(picker, animated: true, completion: nil)
        }
    }
    /********************************************************************************/

}
