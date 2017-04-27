//
//  ContactsViewController.swift
//  Alpa
//
//  Created by ROHAN DAVE on 31/07/16.
//  Copyright © 2016 Rohan Dave. All rights reserved.
//

import UIKit

import RealmSwift


class ContactsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // MARK:
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    var contactsArray: [FacebookFriendProperties] = []
    var hasAnyContacts: Bool! = false
    

    // MARK:
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Nav Bar Setup
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("PEOPLE", comment: "")
        self.setupGradientBackground()
        
        // Get contacts from Realm Database
        self.contactsArray = self.getContactsArrayOnDiskWithRealm()
        if (self.contactsArray.count > 0) {
            self.hasAnyContacts = true
        }
        
        // TableView Setup
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 78.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    // MARK:
    // MARK: UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.contactsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RecentLettersCell", for: indexPath) as? RecentLettersTableViewCell {
            
            if (self.hasAnyContacts == true) {
                let name = self.contactsArray[indexPath.row].name
                let imageUrl = self.contactsArray[indexPath.row].profilePictureUrl
                
                cell.configureCell(name: name, profileImageUrl: imageUrl, profileImage: nil, lastLetterBriefLine: "")
            }
            
            return cell
        }
        
        return RecentLettersTableViewCell()
    }
    
    
    // MARK:
    // MARK: UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "AllConversationsViewController") as? AllConversationsViewController  {
            controller.recipientContactProperties = self.contactsArray[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let contactCell = cell as? RecentLettersTableViewCell {
            
            let imageCache = CacheService.cacheService
            let imageUrl = self.contactsArray[indexPath.row].profilePictureUrl
            let fbUserId = self.contactsArray[indexPath.row].facebookUserId
            
            if let userImage = imageCache.fetchUserImageFromCache(fbUserId: fbUserId) {
                contactCell.configureCellWithUserImage(userImage: userImage)
            }
            else {
                contactCell.profilePictureImageView.image = nil
                
                DataService.dataService.fetchUserImageFromURL(imageUrl: imageUrl, fbUserId: fbUserId, completion: { (userImage) in
                    
                    if let image = userImage {
                        contactCell.configureCellWithUserImage(userImage: image)
                        
                        imageCache.cacheDownloadedProfileImage(image: image, fbUserId: fbUserId)
                    }
                })
            }
        }
    }
    
    
    // MARK:
    // MARK: Helper Methods
    
    private func getContactsArrayOnDiskWithRealm() -> [FacebookFriendProperties] {
        
        var contactsArray: [FacebookFriendProperties] = []
        
        if let recentContactsRealmResults = realmDatabase.object(ofType: FacebookFriendList.self, forPrimaryKey: "false" as AnyObject) {
            for friend in recentContactsRealmResults.friendList {
                contactsArray.append(friend)
            }
        }
        
        return contactsArray
    }

}
