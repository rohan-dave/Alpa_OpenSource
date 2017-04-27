//
//  LoginTutorialSignInViewController.swift
//  Alpa
//
//  Created by ROHAN DAVE on 15/04/17.
//  Copyright © 2017 Rohan Dave. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit



protocol LoginTutorialSignInViewControllerDelegate {
    
    func didTapFacebookLoginButton()
}


class LoginTutorialSignInViewController: UIViewController {

    
    // MARK:
    // MARK: Properties
    
    @IBOutlet weak var welcomeMessageLabel: UILabel!
    @IBOutlet weak var facebookLoginButton: ButtonWithBorder!
    var delegate: LoginTutorialSignInViewControllerDelegate? = nil
    
    
    // MARK:
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
    }
    
    
    // MARK: 
    // MARK: Action methods
    
    @IBAction func didTapFacebookLoginButton(_ sender: UIButton) {
        
        self.delegate?.didTapFacebookLoginButton()
    }
}
