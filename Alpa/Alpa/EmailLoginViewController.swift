//
//  EmailLoginViewController.swift
//  Alpa
//
//  Created by ROHAN DAVE on 24/07/16.
//  Copyright © 2016 Rohan Dave. All rights reserved.
//

import UIKit
import Firebase



class EmailLoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: ButtonWithBorder!
    @IBOutlet weak var signUpButton: ButtonWithBorder!
    
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    // MARK: Action methods
    
    @IBAction func didTapSignUpButton(sender: UIButton) {
        
        if (self.validateEmailAndPasswordFields() == true) {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "NewUserLoginViewController") as? NewUserLoginViewController
            controller?.emailIdForSignUp = self.emailTextField.text
            controller?.passwordForSignUp = self.passwordTextField.text
            
            self.navigationController?.pushViewController(controller!, animated: true)
        }
    }
    
    @IBAction func didTapLoginButton(sender: UIButton) {
        
        if (self.validateEmailAndPasswordFields() == true) {
            FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                
                if (error != nil) {
                    //TODO: Handle error here!
                } else {
                    if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTabbedViews") as? UITabBarController  {
                        self.navigationController?.present(controller, animated: true, completion: nil)
                    }
                }
                
            })
        }
    }
    
    
    // MARK: Validation 
    
    func validateEmailAndPasswordFields() -> Bool {
        
        var isDataValid: Bool = true
        
        if let email = self.emailTextField.text {
            
            if (email.contains("@") == false || email.contains(".") == false) {
                self.changeTextFieldBorderColor(textField: self.emailTextField)
                isDataValid = false
            }
        }
        else {
            //Email not filled out
            self.changeTextFieldBorderColor(textField: self.emailTextField)
            isDataValid = false
        }
        
        if let password = self.passwordTextField.text {
            
            if (password.characters.count < 6) {
                self.changeTextFieldBorderColor(textField: self.passwordTextField)
                isDataValid = false
            }
            
            if (password.characters.count > 32) {
                self.changeTextFieldBorderColor(textField: self.passwordTextField)
                isDataValid = false
            }
        } else {
            //Password not filled out.
            self.changeTextFieldBorderColor(textField: self.passwordTextField)
            isDataValid = false
        }
        
        return isDataValid
    }
    
    
    // MARK: Helper methods
    
    func changeTextFieldBorderColor(textField: UITextField!) {
        
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.red.cgColor
    }
}
