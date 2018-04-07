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
    
    //#MARK: Varible Declarations
    let back_color_ = UserDefaults.standard.color(forKey: "backColor")
    let labels_color_ = UserDefaults.standard.color(forKey: "labelsColor")
    let text_color_ = UserDefaults.standard.color(forKey: "textColor")
    var token = String()
    var original_stack_bottom_const_ : CGFloat = 0.0
    var original_logo_top_const_ : CGFloat = 0.0
    var dist_from_top_ : CGFloat = 0.0
    
    //#MARK: Coupling Variables
    @IBOutlet weak var main_stack_bottom_stack_dist_: NSLayoutConstraint!
    @IBOutlet weak var bottom_stack_view_: UIStackView!
    @IBOutlet weak var signup_button_: UIButton!
    @IBOutlet weak var login_button_: UIButton!
    @IBOutlet weak var activity_indicator_: UIActivityIndicatorView!
    @IBOutlet weak var main_stack_: UIStackView!
    @IBOutlet weak var logo_: UIImageView!
    @IBOutlet weak var email_text_field_: UITextField!
    @IBOutlet weak var psw_text_field_: UITextField!
    @IBOutlet weak var bottom_stack_bottom_const_: NSLayoutConstraint!
    @IBOutlet weak var stack_view_height_: NSLayoutConstraint!
    @IBOutlet weak var stack_view_: UIView!
    @IBOutlet weak var main_stack_height: NSLayoutConstraint!
    @IBOutlet weak var logo_top_const_: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch UIDevice.current.getDeviceType() {
            case .iPhone4:
                self.dist_from_top_ = 0
            case .iPhones5:
                self.dist_from_top_ = 0
            case .iPhones6_7_8:
                self.dist_from_top_ = 0
            case .iPhones6_7_8Plus:
                self.dist_from_top_ = 0
            case .iPhoneX:
                self.dist_from_top_ = 20
            default:
                self.dist_from_top_ = 100
        }
        
        self.view.backgroundColor = labels_color_
        self.stack_view_.backgroundColor = labels_color_
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: text_color_!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: labels_color_!], for: .selected)
        
        setupLogo()
        setupInputFields()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    /************************************************/
    
    //MARK: Setup Graphics
    func setupLogo(){
        let image = UIImage(named: "Genio_Logo")
        self.logo_.image =  image?.maskWithColor(color: UIColor.white)
    }
    func setupInputFields() {
        
        var height: CGFloat = self.view.bounds.height * 0.18
        height = height  * 0.7
        
        let radius : CGFloat = (height - (self.main_stack_.spacing)) / 4
        
        self.email_text_field_.delegate = self
        self.email_text_field_.setLeftPaddingPoints(10)
        self.email_text_field_.setRightPaddingPoints(10)
        self.email_text_field_.layer.cornerRadius =  radius
        self.email_text_field_.layer.borderColor = UIColor.white.cgColor
        
        self.psw_text_field_.delegate = self
        self.psw_text_field_.setLeftPaddingPoints(10)
        self.psw_text_field_.setRightPaddingPoints(10)
        self.psw_text_field_.layer.cornerRadius = radius
        self.psw_text_field_.layer.borderColor = UIColor.white.cgColor
        
        self.activity_indicator_.stopAnimating()
        self.activity_indicator_.hidesWhenStopped = true
    }
    
    
    //#MARK: Action
    @IBAction func loginAction(_ sender: UIButton) {
        checkEmailAndPsw(sender: sender)
    }
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
        
    }
    
    /***************************************/
    
    //MARK: Textfield actions/graphics
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.original_stack_bottom_const_ = self.bottom_stack_bottom_const_.constant
        self.original_logo_top_const_ = self.logo_top_const_.constant
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveLinear], animations: {
            print(self.view.bounds.height)
            print(self.logo_top_const_.constant)
            print(self.view.safeAreaInsets.top)
            print(self.stack_view_.bounds.height)
            self.bottom_stack_bottom_const_.constant = self.view.bounds.height - self.view.safeAreaInsets.top - self.stack_view_.bounds.height - self.bottom_stack_view_.bounds.height - self.main_stack_bottom_stack_dist_.constant - self.dist_from_top_
            print(self.bottom_stack_bottom_const_.constant)
            
            self.logo_top_const_.constant = -700
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveLinear], animations: {
            self.bottom_stack_bottom_const_.constant = self.original_stack_bottom_const_
            self.logo_top_const_.constant = self.original_logo_top_const_
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /***************************************/
}


    
    



