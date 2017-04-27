//
//  MyProfileViewController.swift
//  Alpa
//
//  Created by ROHAN DAVE on 10/04/17.
//  Copyright © 2017 Rohan Dave. All rights reserved.
//

import UIKit



class MyProfileViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    
    // MARK:
    // MARK: Properties
    
    @IBOutlet weak private var tableView: UITableView!
    private var userName: String?
    
    
    // MARK:
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupGradientBackground()
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("PROFILE", comment: "")
        
        // Table View Setup
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.estimatedRowHeight = 138.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Get user name
        self.userName = AuthService.authService.getCurrentUserProviderProfile()?.displayName
    }
    
    
    // MARK:
    // MARK: UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // Currently only Profile and Logout sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // One cell for each section.
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return self.profileCell(tableView: tableView, indexPath: indexPath)
    }
    
    // MARK: 
    // MARK: UITableViewDelegate Methods
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let profileCell = cell as? ProfileTableViewCell, let providerProfile = AuthService.authService.getCurrentUserProviderProfile() {
            
            let imageCache = CacheService.cacheService
            let imageUrl = providerProfile.photoURL?.absoluteString
            let fbUserId = providerProfile.uid
            
            if let userImage = imageCache.fetchUserImageFromCache(fbUserId: fbUserId) {
                profileCell.configureCellWithUserImage(userImage: userImage)
            }
            else {
                DataService.dataService.fetchUserImageFromURL(imageUrl: imageUrl, fbUserId: fbUserId, completion: { (userImage) in
                    
                    if let image = userImage {
                        imageCache.cacheDownloadedProfileImage(image: image, fbUserId: fbUserId)
                        
                        profileCell.configureCellWithUserImage(userImage: image)
                    }
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView.bounds.size.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    
    
    // MARK:
    // MARK: Private Helper Methods
    
    private func profileCell(tableView: UITableView, indexPath: IndexPath) -> ProfileTableViewCell {
        
        if let profileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell {
            
            if (self.userName != nil) {
                profileCell.configureProfileCell(userNameText: self.userName!)
                
                return profileCell
            }
        }
        
        return ProfileTableViewCell()
    }
    
    private func logOutCell(tableView: UITableView, indexPath: IndexPath) -> LogOutTableViewCell {
        
        if let logoutCell = tableView.dequeueReusableCell(withIdentifier: "LogOutTableViewCell", for: indexPath) as? LogOutTableViewCell {
            
            //logoutCell.delegate = self
            return logoutCell
        }
        
        return LogOutTableViewCell()
    }
}
