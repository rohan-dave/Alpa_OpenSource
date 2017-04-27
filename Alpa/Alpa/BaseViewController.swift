//
//  BaseViewController.swift
//  Alpa
//
//  Created by ROHAN DAVE on 19/03/17.
//  Copyright © 2017 Rohan Dave. All rights reserved.
//

import UIKit



class BaseViewController: UIViewController {

    
    // MARK:
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupTabBar()
        self.setupNavBar()
    }
    
    
    // MARK:
    // MARK: Overriden Methods
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    
    // MARK:
    // MARK: Public Methods
    
    func setupGradientBackground() {
        // Gradient Colors
        let gradientOrangeColor: UIColor! = UIColor.colorForOrangeGradientWithAlpha(alpha: 0.9)
        let gradientMidOrangeColor: UIColor! = UIColor.colorForMidOrangeGradientWithAlpha(alpha: 0.9)
        let gradientYellowColor: UIColor! = UIColor.colorForYellowGradientWithAlpha(alpha: 0.9)
        
        // View Gradient Setup
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [gradientOrangeColor.cgColor, gradientMidOrangeColor.cgColor,gradientYellowColor.cgColor]
        gradient.startPoint = CGPoint.zero
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    func presentAlertControllerWithOkButton(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK:
    // MARK: Private Helper Methods
    
    private func setupTabBar() {
        
        self.tabBarController?.tabBar.isTranslucent = false
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        self.tabBarController?.tabBar.tintColor = UIColor.white
    }
    
    private func setupNavBar() {
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.isTranslucent = false
    }
}
