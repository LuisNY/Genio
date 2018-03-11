//
//  Login.swift
//  Genio
//
//  Created by Luigi Pepe on 2/28/18.
//  Copyright © 2018 Luigi Pepe. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    
    let back_color_ = UserDefaults.standard.color(forKey: "backColor")
    let labels_color_ = UserDefaults.standard.color(forKey: "labelsColor")
    let text_color_ = UserDefaults.standard.color(forKey: "textColor")
    var token = String()
    var original_stack_bottom_const_ : CGFloat = 0.0
    
    /*********************************************/
    @IBOutlet weak var signup_button_: UIButton!
    @IBOutlet weak var login_button_: UIButton!
    @IBOutlet weak var activity_indicator_: UIActivityIndicatorView!
    @IBOutlet weak var main_stack_: UIStackView!
    @IBOutlet weak var logo_: UIImageView!
    @IBOutlet weak var email_text_field_: UITextField!
    @IBOutlet weak var psw_text_field_: UITextField!
    @IBOutlet weak var main_stack_bottom_const_: NSLayoutConstraint!
    @IBOutlet weak var main_stack_height_: NSLayoutConstraint!
    @IBOutlet weak var stack_view_: UIView!
    @IBOutlet weak var stack_view_top_distance_: NSLayoutConstraint!
    @IBOutlet weak var logo_top_const_: NSLayoutConstraint!
    /*********************************************/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        self.view.backgroundColor = labels_color_
        self.stack_view_.backgroundColor = labels_color_
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: text_color_!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: labels_color_!], for: .selected)
        setupLogo()
        setupBottomStack()
        setUpinputFields()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupLogo(){
        let image = UIImage(named: "Genio_Logo")
        self.logo_.image =  image?.maskWithColor(color: UIColor.white)
        self.logo_.tintColor = UIColor.white
    }
    
    func setupBottomStack(){
        self.login_button_.titleLabel?.font = UIFont(name: "BrandonGrotesque-Regular", size: 18)
        self.login_button_.setTitle("LOG IN", for: .normal)
        self.login_button_.setTitleColor(UIColor.white, for: .normal)
        self.login_button_.backgroundColor = UIColor.clear
        self.signup_button_.titleLabel?.font = UIFont(name: "BrandonGrotesque-Regular", size: 18)
        self.signup_button_.setTitle("SIGN UP", for: .normal)
        self.signup_button_.setTitleColor(UIColor.white, for: .normal)
        self.signup_button_.backgroundColor = UIColor.clear
    }
    
    
    
    func setUpinputFields() {
        self.email_text_field_.delegate = self
        self.email_text_field_.setLeftPaddingPoints(10)
        self.email_text_field_.setRightPaddingPoints(10)
        self.email_text_field_.layer.cornerRadius = (((self.view.bounds.height * 0.3) - stack_view_top_distance_.constant - (self.main_stack_.spacing * 2)) / 3) / 2
        self.email_text_field_.layer.borderColor = UIColor.white.cgColor
        self.psw_text_field_.delegate = self
        self.psw_text_field_.setLeftPaddingPoints(10)
        self.psw_text_field_.setRightPaddingPoints(10)
        self.psw_text_field_.layer.cornerRadius = (((self.view.bounds.height * 0.3) - stack_view_top_distance_.constant - (self.main_stack_.spacing * 2)) / 3) / 2
        self.psw_text_field_.layer.borderColor = UIColor.white.cgColor
        self.activity_indicator_.stopAnimating()
        self.activity_indicator_.hidesWhenStopped = true
    }
    
    
    
    
    
    @IBAction func loginAction(_ sender: UIButton) {
        
         print("login")
        
        
    }
    
    @IBAction func signupAction(_ sender: UIButton) {
        print("sign up")
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return")
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.original_stack_bottom_const_ = self.main_stack_bottom_const_.constant
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveLinear], animations: {
            self.main_stack_bottom_const_.constant = (self.view.bounds.height - self.logo_top_const_.constant - self.view.safeAreaInsets.top - self.stack_view_.bounds.height)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveLinear], animations: {
                self.main_stack_bottom_const_.constant = self.original_stack_bottom_const_
                self.view.layoutIfNeeded()
            }, completion: nil)
        
            self.view.endEditing(true)
        }
    }
    
    



