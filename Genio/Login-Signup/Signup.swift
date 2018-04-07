//
//  Signup.swift
//  Genio
//
//  Created by Luigi Pepe on 3/11/18.
//  Copyright © 2018 Luigi Pepe. All rights reserved.
//

import Foundation
import UIKit

class SignupViewController: UIViewController,
                            UITextFieldDelegate,
                            UIImagePickerControllerDelegate,
                            UINavigationControllerDelegate,
                            UIScrollViewDelegate {
    
    let back_color_ = UserDefaults.standard.color(forKey: "backColor")
    let labels_color_ = UserDefaults.standard.color(forKey: "labelsColor")
    let text_color_ = UserDefaults.standard.color(forKey: "textColor")
    
    //#MARK: outlets
    @IBOutlet weak var profile_image_view_: UIImageView!
    @IBOutlet weak var activity_indicator: UIActivityIndicatorView!
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectProfilePic))
        profile_image_view_.isUserInteractionEnabled = true
        tap.numberOfTapsRequired = 1
        profile_image_view_.addGestureRecognizer(tap)
        setupTextFields()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    //press done to complete registration
    @IBAction func doneAction(_ sender: UIButton) {
        checkSignupFields()
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
    
    
    
}
