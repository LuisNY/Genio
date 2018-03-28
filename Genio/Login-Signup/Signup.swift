//
//  Signup.swift
//  Genio
//
//  Created by Luigi Pepe on 3/11/18.
//  Copyright © 2018 Luigi Pepe. All rights reserved.
//

import Foundation
import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate  {
    
    
    let back_color_ = UserDefaults.standard.color(forKey: "backColor")
    let labels_color_ = UserDefaults.standard.color(forKey: "labelsColor")
    let text_color_ = UserDefaults.standard.color(forKey: "textColor")
    
    //#MARK: Variables
    @IBOutlet weak var top_stack_: UIStackView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var confirmpasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var top_stack_height_: NSLayoutConstraint!
    
    
    //#MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        print(top_stack_.bounds.size.height)
        print(top_stack_.spacing)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTextFields()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func setupTextFields() {
        
        let height = self.view.bounds.height * 0.47
        let radius : CGFloat = (height - (self.top_stack_.spacing * 4)) / 20
        
        print("radius" , radius)
        
        self.usernameTextField.delegate = self
        self.usernameTextField.setLeftPaddingPoints(10)
        self.usernameTextField.setRightPaddingPoints(10)
        self.usernameTextField.layer.cornerRadius = radius
        self.usernameTextField.layer.borderColor = UIColor.white.cgColor
        self.usernameTextField.layer.borderWidth = 0
        
        self.fullnameTextField.delegate = self
        self.fullnameTextField.setLeftPaddingPoints(10)
        self.fullnameTextField.setRightPaddingPoints(10)
        self.fullnameTextField.layer.cornerRadius = radius
        self.fullnameTextField.layer.borderColor = UIColor.white.cgColor
        
        self.emailTextField.delegate = self
        self.emailTextField.setLeftPaddingPoints(10)
        self.emailTextField.setRightPaddingPoints(10)
        self.emailTextField.layer.cornerRadius = radius
        self.emailTextField.layer.borderColor = UIColor.white.cgColor
        
        self.confirmpasswordTextField.delegate = self
        self.confirmpasswordTextField.setLeftPaddingPoints(10)
        self.confirmpasswordTextField.setRightPaddingPoints(10)
        self.confirmpasswordTextField.layer.cornerRadius = radius
        self.confirmpasswordTextField.layer.borderColor = UIColor.white.cgColor
        
        self.passwordTextField.delegate = self
        self.passwordTextField.setLeftPaddingPoints(10)
        self.passwordTextField.setRightPaddingPoints(10)
        self.passwordTextField.layer.cornerRadius = radius
        self.passwordTextField.layer.borderColor = UIColor.white.cgColor
        
        
    }
    
    
    
    //#MARK: Actions
    
    /*@IBAction func selectimagefromlibraryGesture(_ sender: UITapGestureRecognizer) {
        /*// UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)*/
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    //#MARK:

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }*/
    
}
