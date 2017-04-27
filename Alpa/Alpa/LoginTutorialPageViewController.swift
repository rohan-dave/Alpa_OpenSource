//
//  LoginTutorialPageViewController.swift
//  Alpa
//
//  Created by ROHAN DAVE on 15/04/17.
//  Copyright © 2017 Rohan Dave. All rights reserved.
//

import UIKit



class LoginTutorialPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    
    // MARK:
    // MARK: Properties
    
    private var pages: [UIViewController] = []
    var viewControllerForParent: LoginViewController? = nil
    
    
    // MARK:
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        // PageViewController Setup
        self.dataSource = self
        self.delegate = self
        
        self.pages = self.setupPagesForPageViewController()
        
        if let pageOne = self.pages.first {
            self.setViewControllers([pageOne], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK:
    // MARK: UIPageViewControllerDataSource Methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let currentIndex = self.pages.index(of: viewController) {
            let previousIndex = self.pages.index(before: currentIndex)
            
            return (previousIndex >= 0) ? self.pages[previousIndex] : nil
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let currentIndex = self.pages.index(of: viewController) {
            let nextIndex = self.pages.index(after: currentIndex)
            
            return (nextIndex < self.pages.count) ? self.pages[nextIndex] : nil
        }
        
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return self.pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return 0
    }
    
    
    // MARK:
    // MARK: Private Helper Methods
    
    private func setupPagesForPageViewController() -> [UIViewController] {
        
        var pageArray = [UIViewController]()
        
        if let pageOne = self.storyboard?.instantiateViewController(withIdentifier: "LoginTutorialSignInViewController") {
            if let loginContoller = pageOne as? LoginTutorialSignInViewController,
                let parentVC = self.viewControllerForParent {
                loginContoller.delegate = parentVC
                
                pageArray.append(loginContoller)
            }
            else {
                pageArray.append(pageOne)
            }
        }
        
        if let pageTwo = self.storyboard?.instantiateViewController(withIdentifier: "LoginTutorialEmotionViewController") {
            pageArray.append(pageTwo)
        }
        
        if let pageThree = self.storyboard?.instantiateViewController(withIdentifier: "LoginTutorialLetterViewController") {
            pageArray.append(pageThree)
        }
        
        return pageArray
    }
}
