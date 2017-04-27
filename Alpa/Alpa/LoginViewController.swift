//
//  LoginViewController.swift
//  Alpa
//
//  Created by ROHAN DAVE on 18/07/16.
//  Copyright © 2016 Rohan Dave. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit



class LoginViewController: BaseViewController, LoginTutorialSignInViewControllerDelegate {
    
    
    // MARK: Life Cycles
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.black;
        
        // Background sunset gradient color
        self.setupGradientBackground()
        
        // Auto sign in
        if let fbAccessToken = FBSDKAccessToken.current()?.tokenString {
            self.handleSuccesfulFacebookLogin(facebookAccessToken: fbAccessToken)
        }
    }
    
    
    // MARK:
    // MARK: Segue Preparation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? LoginTutorialPageViewController {
            controller.viewControllerForParent = self
        }
    }
    
    
    // MARK: 
    // MARK: LoginTutorialSignInViewControllerDelegate Methods
    
    func didTapFacebookLoginButton() {
        
        let facebookLoginManager: FBSDKLoginManager! = FBSDKLoginManager()
        
        // TODO: Think of alternate route here.
        facebookLoginManager.logOut()
        
        facebookLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (facebookResult:FBSDKLoginManagerLoginResult?, facebookLoginError: Error?) in
            
            if (facebookLoginError != nil) {
                //TODO: add a UIAlert to display the error message.
                print("Facebook login failed. Error \(String(describing: facebookLoginError?.localizedDescription))")
                return
            }
            
            if let facebookAccessToken = FBSDKAccessToken.current()?.tokenString {
                self.handleSuccesfulFacebookLogin(facebookAccessToken: facebookAccessToken)
            }
            
            //TODO: handle other kind of errors here: Could not get the token, user may have tapped cancel in Facebook.
        }
    }
    
    
    // MARK:
    // MARK: Private Helper Methods
    
    private func handleSuccesfulFacebookLogin(facebookAccessToken: String!) {
        
        // Add the user to Firebase with the Facebook access token.
        let firebaseCredential = FIRFacebookAuthProvider.credential(withAccessToken: facebookAccessToken)
        
        // Firebase sign in with facebook auth credentials
        FIRAuth.auth()?.signIn(with: firebaseCredential, completion: { (user: FIRUser?, firebaseAuthError: Error?) in
            
            if let error = firebaseAuthError {
                //TODO: handle errors here, see Firebase docs
                print(error.localizedDescription)
                return
            }
            
            let providerProfile = user?.providerData.first
            
            self.storeUserAuthDataForSession(user: user, providerProfile: providerProfile)
            self.postUserAuthDataToFirebase(user: user, providerProfile: providerProfile)
            self.loginToPresentHomeViewController()
        })
    }
    
    private func storeUserAuthDataForSession(user: FIRUser?, providerProfile: FIRUserInfo?) {
        
        // Set the global currentUserId in AppDelegate.
        currentUserId = user?.uid
        
        // Set the global currentUserFacebookId in AppDelegate.
        currentUserFacebookId = providerProfile?.uid
    }
    
    private func postUserAuthDataToFirebase(user: FIRUser?, providerProfile: FIRUserInfo?) {
        
        DataService.dataService.postUserProfileInDatabase(currentUser: user, uid: providerProfile?.uid, name: providerProfile?.displayName, email: providerProfile?.email, photoUrl: providerProfile?.photoURL?.absoluteString, authProvider: providerProfile?.providerID)
    }
    
    private func loginToPresentHomeViewController() {
        
        // Open recentContacts as the login is successfull.
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTabbedViews") as? UITabBarController  {
            self.navigationController?.present(controller, animated: true, completion: nil)
            
            print("Facebook login successfull.")
        }
    }
    
    private func handleDeclinedFacebookPermissions(facebookResult:FBSDKLoginManagerLoginResult?) {
        
        if (facebookResult?.declinedPermissions?.contains("user_friends") == true) {
            //TODO: Else get friend list and store in firebase
            print("declined friend list")
            return
        }
    }

}
