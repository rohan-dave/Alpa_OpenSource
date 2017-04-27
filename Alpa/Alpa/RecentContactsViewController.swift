//
//  RecentContactsViewController.swift
//  Alpa
//
//  Created by ROHAN DAVE on 31/07/16.
//  Copyright © 2016 Rohan Dave. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseDatabase
import FBSDKCoreKit
import SwiftyJSON
import RealmSwift
import AlamofireImage



class RecentContactsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK:
    // MARK: Class Properties
    @IBOutlet weak var tableView: UITableView!

    var recentContactsArray: [FacebookFriendProperties] = []
    var mostRecentContactsArray: [FacebookFriendProperties] = []
    var hasAnyRecentContacts: Bool!
    
    
    // MARK:
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Nav Bar Setup
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("CONVERSATIONS", comment: "")
        // Set the back button for the next view controller because "Conversations" is too long to fit in.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: .done, target: nil, action: nil)
        
        // Gradient Setup
        self.setupGradientBackground()
        
        self.hasAnyRecentContacts = false
        
        // TableView Setup
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 78.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Get most recently offline contacts saved.
        self.mostRecentContactsArray = self.getMostRecentContactsArrayOnDiskWithRealm()
        
        // Get facebook friend list from Facebook.
        self.getFacebookFriendsForUser(currentUser: AuthService.authService.getCurrentUser())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Get sorted recent contacts list from Firebase.
        self.getRecentContactsFacebookIdFromFirebase()
    }
    
    
    // MARK:
    // MARK: UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.mostRecentContactsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RecentLettersCell") as? RecentLettersTableViewCell {
            
            if (self.hasAnyRecentContacts == true) {
                let name = self.mostRecentContactsArray[indexPath.row].name
                let imageUrl = self.mostRecentContactsArray[indexPath.row].profilePictureUrl
        
                cell.configureCell(name: name, profileImageUrl: imageUrl, profileImage: nil, lastLetterBriefLine: "")
                
                return cell
            }
        }
        
        return RecentLettersTableViewCell()
    }
    
    
    // MARK:
    // MARK: UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (self.hasAnyRecentContacts == false) {
            return
        }
        
        if let contactCell = cell as? RecentLettersTableViewCell {
            
            let imageCache = CacheService.cacheService
            let imageUrl = self.mostRecentContactsArray[indexPath.row].profilePictureUrl
            let fbUserId = self.mostRecentContactsArray[indexPath.row].facebookUserId
            
            if let userImage = imageCache.fetchUserImageFromCache(fbUserId: fbUserId) {
                contactCell.configureCellWithUserImage(userImage: userImage)
            }
            else {
                DataService.dataService.fetchUserImageFromURL(imageUrl: imageUrl, fbUserId: fbUserId, completion: { (userImage) in
                    
                    if let image = userImage {
                        contactCell.configureCellWithUserImage(userImage: image)
                        
                        imageCache.cacheDownloadedProfileImage(image: image, fbUserId: fbUserId)
                    }
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "AllConversationsViewController") as? AllConversationsViewController  {
            controller.recipientContactProperties = self.mostRecentContactsArray[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    // MARK:
    // MARK: Data Loading
    
    func getRecentContactsFacebookIdFromFirebase() {
        
        let ref = DataService.dataService.userRecentContactsReference
        ref.queryOrderedByValue().observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.mostRecentContactsArray = []
                for snap in snapshot {
                    for recentContact in self.recentContactsArray {
                        if (recentContact.facebookUserId == snap.key) {
                            self.mostRecentContactsArray.append(recentContact)
                        }
                    }
                }
                
                self.mostRecentContactsArray = self.mostRecentContactsArray.reversed()
                self.saveMostRecentContactsOnDiskWithRealm(friendsPropertiesArray: self.mostRecentContactsArray)
                self.tableView.reloadData()
            }
        })
    }
    
    func getFacebookFriendsForUser(currentUser: FIRUser?) {
        
        let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: ["fields":"uid, email, name, picture.width(400).height(400)"] , httpMethod: "GET")
        
        request.start { (connection: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
            
            if let error = error {
                print(error)
            } else {
                
                let facebookFriendsObject: FacebookFriendList! = FacebookFriendList(resultObject: JSON(result as Any), isRecentContacts: "false")
                
                self.updateRealmDatabaseIfRequired(friendsObject: facebookFriendsObject)
                self.recentContactsArray = self.getRecentContactsArrayOnDiskWithRealm()
                
                if (self.recentContactsArray.count > 0) {
                    self.hasAnyRecentContacts = true
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK:
    // MARK: Helper Methods
    
    // MARK: Realm
    
    func saveMostRecentContactsOnDiskWithRealm(friendsPropertiesArray: [FacebookFriendProperties]) {
        
        let recentContactsObject: MostRecentContactsList = MostRecentContactsList()
        
        for recentContact in friendsPropertiesArray {
            recentContactsObject.recentContactsList.append(recentContact)
        }
        
        try! realmDatabase.write {
            realmDatabase.add(recentContactsObject)
        }
    }
    
    func getMostRecentContactsArrayOnDiskWithRealm() -> [FacebookFriendProperties] {
        
        let recentContactsRealmResults = realmDatabase.objects(MostRecentContactsList.self)
        
        if let recentContactsList = recentContactsRealmResults.first?.recentContactsList {
            let contactsArray = Array(recentContactsList)
            return contactsArray
        }
        
        return []
    }
    
    func saveRecentContactsOnDiskWithRealm(friendsObject: FacebookFriendList!) {
        
        try! realmDatabase.write {
            realmDatabase.add(friendsObject, update: true)
        }
    }
    
    func getRecentContactsArrayOnDiskWithRealm() -> [FacebookFriendProperties] {
        
        var contactsArray: [FacebookFriendProperties] = []
        
        if let recentContactsRealmResults = realmDatabase.object(ofType: FacebookFriendList.self, forPrimaryKey: "false" as AnyObject) {
            for friend in recentContactsRealmResults.friendList {
                contactsArray.append(friend)
            }
        }
        
        return contactsArray
    }
    
    func updateRealmDatabaseIfRequired(friendsObject: FacebookFriendList!) {
        
        if (self.recentContactsArray.count >= friendsObject.friendList.count) {
            for friend in self.recentContactsArray {
                // Compare each friend with one saved in Realm Database, if a difference is found, update it.
                if (friendsObject.friendList.contains(where: FacebookFriendProperties.isEqualToObject(friend)) == false) {
                    self.saveRecentContactsOnDiskWithRealm(friendsObject: friendsObject)
                    return
                }
            }
        } else {
            for friend in friendsObject.friendList {
                // Compare each friend with one saved in Realm Database, if a difference is found, update it.
                if (self.recentContactsArray.contains(where: FacebookFriendProperties.isEqualToObject(friend)) == false) {
                    self.saveRecentContactsOnDiskWithRealm(friendsObject: friendsObject)
                    return
                }
            }
        }
    }
}
