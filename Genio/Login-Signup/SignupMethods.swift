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
        
        var url_username = UserDefaults.standard.string(forKey: "myURL")!
        url_username = url_username + "register/exists/" + insertedUserName
        
        let username_request = NSMutableURLRequest(url: NSURL(string: url_username)! as URL)
        username_request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        username_request.httpMethod = "GET"
        
        httpRequest(request: username_request) {
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
                        self.showAlert(message: "An error occurred", title: "Signup Error")
                    }
                }
                if let username_message = jsonObject?["message"] as? String {
                    if username_message == "NOT_PRESENT" {   //user name is good
                        var url_email = UserDefaults.standard.string(forKey: "myURL")!
                        url_email = url_email + "register/exists/" + insertedEmail
                        
                        let email_request = NSMutableURLRequest(url: NSURL(string: url_email)! as URL)
                        email_request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                        email_request.httpMethod = "GET"
                        
                        httpRequest(request: email_request) {
                            (data, error, response) -> Void in
                            
                            if error == nil {
                                
                                var jsonObject2: Dictionary<String, AnyObject>?
                                do {
                                    jsonObject2 = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String,AnyObject>
                                } catch {
                                    DispatchQueue.main.async {
                                        self.repristinateView()
                                        self.showAlert(message: "An error occurred", title: "Signup Error")
                                    }
                                }
                                if let email_message = jsonObject2?["message"] as? String {
                                    
                                    if email_message == "NOT_PRESENT" {  // email is good
                                        
                                        let validEmail = isValidEmail(testStr: insertedEmail)
                                        let lengthPsw = isPswLenth(password: insertedPassword)
                                        let validPsw = isPswSame(password: insertedPassword, confirmPassword: confirmationPassword)
                                        
                                        if validEmail && lengthPsw && validPsw { //all arguments are good
                                            
                                            let fbID = UserDefaults.standard.string(forKey: "fbID")
                                            
                                            var signup_request : NSMutableURLRequest?
                                            DispatchQueue.main.async {
                                                 signup_request = signUpRequest(instertedUserName: insertedUserName, insertedEmail: insertedEmail, insertedPassword: insertedPassword, insertedFullName: insertedFullName, profileImage: self.profile_image_view_.image, facebookID: fbID, iOSDeviceToken: nil)
                                            }
                                            if signup_request == nil {
                                                self.showAlert(message: "An error occurred", title: "Signup Error")
                                                return
                                            }
                                            
                                            httpRequest(request: signup_request){
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
                                                        self.showAlert(message: "An error occurred", title: "Signup Error")
                                                    }
                                                }
                                                
                                                print(jsonObject ?? 0)
                                                if error != nil  || data == nil || (httpResponse?.statusCode)! >= 400 || (httpResponse?.statusCode)! < 200  {
                                                    let alert = createAlert(title: "Sign Up Error", message: "An Error Occurred")
                                                    self.present(alert, animated: true, completion: nil)
                                                } else {
                                                    DispatchQueue.main.async {
                                                        self.showAlert(message: "Please check your email and follow instructions to complete your registration", title: "Complete Sign Up")
                                                    }
                                                }
                                            }
                                        } else {
                                            
                                            let tapProfilePic: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectProfilePic))
                                            
                                            DispatchQueue.main.async {
                                                if insertedPassword == "" || insertedEmail == "" || insertedUserName == "" {
                                                    self.showAlert(message: "Please enter UserName, Email and Password", title: "Signup Error")
                                                } else if validEmail == false {
                                                    self.showAlert(message: "Please enter a valid Email address", title: "Signup Error")
                                                } else if lengthPsw == false {
                                                    self.showAlert(message: "Password must have at least 8 carachters", title: "Signup Error")
                                                } else {
                                                    self.showAlert(message: "Wrong confirmation Password", title: "Signup Error")
                                                }
                                                self.repristinateView()
                                                self.profile_image_view_.addGestureRecognizer(tapProfilePic)
                                            }
                                        }
                                    } else {
                                        
                                        let tapProfilePic: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectProfilePic))
                                        DispatchQueue.main.async {
                                            self.repristinateView()
                                            self.profile_image_view_.addGestureRecognizer(tapProfilePic)
                                            self.showAlert(message: "Your Email already exists", title: "Error")
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        
                        let tapProfilePic: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectProfilePic))
                        DispatchQueue.main.async {
                            self.repristinateView()
                            self.profile_image_view_.addGestureRecognizer(tapProfilePic)
                            self.showAlert(message: "Your Username already exists", title: "Error")
                        }
                    }
                }
            }
        }
    }
    
    
    /********************************************************************************/
    
    func showAlert(message: String, title: String = "Signup Error") {
        self.activity_indicator.stopAnimating()
        let alert = createAlert(title: title, message: message)
        self.present(alert, animated: true, completion: nil)
    }
    
    /********************************************************************************/
    
    func repristinateView(){
            self.emailTextField.isEnabled = true
            self.fullnameTextField.isEnabled = true
            self.usernameTextField.isEnabled = true
            self.passwordTextField.isEnabled = true
            self.confirmpasswordTextField.isEnabled = true
            self.activity_indicator.stopAnimating()
    }
    
    /********************************************************************************/

    @objc func selectProfilePic() {
        
        let actionController = UIAlertController(title: "Photo", message: nil, preferredStyle: .actionSheet)
        let newPhotoAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action  in  self.accessLibrary()  } )
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action  in  self.accessCamera()  } )
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionController.addAction(newPhotoAction)
        actionController.addAction(cameraAction)
        actionController.addAction(cancelAction)
        
        actionController.popoverPresentationController?.sourceView = self.profile_image_view_
        
        DispatchQueue.main.async {
            self.present(actionController, animated: true, completion: nil)
        }
    }

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

    
    @objc internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var chosen_image : UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            chosen_image = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            chosen_image = originalImage
        }
        
        if (chosen_image != nil) {
            
            var height = chosen_image!.size.height
            var width = chosen_image!.size.width
            while (width * height > 90000) {
                width *= 0.8
                height *= 0.8
            }
            let resized_image = chosen_image!.resizeImage(image: chosen_image!, withSize: CGSize(width: width, height: height))
            
            DispatchQueue.main.async {
                self.profile_image_view_.image = resized_image
                self.profile_image_view_.layer.borderWidth = 1
                self.profile_image_view_.layer.masksToBounds = false
                self.profile_image_view_.layer.borderColor = UIColor.white.cgColor
                self.profile_image_view_.layer.cornerRadius = self.profile_image_view_.frame.height/2
                self.profile_image_view_.clipsToBounds = true
                self.profile_image_view_.contentMode = .scaleAspectFill
            }
        }
        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    /********************************************************************************/
    
}
