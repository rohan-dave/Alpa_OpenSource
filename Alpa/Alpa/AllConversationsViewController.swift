//
//  AllConversationsViewController.swift
//  Alpa
//
//  Created by ROHAN DAVE on 31/07/16.
//  Copyright © 2016 Rohan Dave. All rights reserved.
//

import UIKit
import AVFoundation

import FirebaseDatabase



class AllConversationsViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    // MARK:
    // MARK: Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    var recipientContactProperties: FacebookFriendProperties!
    var conversationId: String!
    var allLettersArray: [Letter] = []
    
    
    // MARK:
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupGradientBackground()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: #selector(AllConversationsViewController.addButtonClicked))
        self.navigationItem.setRightBarButton(barButtonItem, animated: true)
        self.navigationItem.title = recipientContactProperties.name
        
        // Fetch the current users profile picture if not already cached
        if (CacheService.cacheService.fetchUserImageFromCache(fbUserId: currentUserFacebookId) == nil) {
            
            let imageUrl = AuthService.authService.getCurrentUserProviderProfile()?.photoURL?.absoluteString
            DataService.dataService.fetchUserImageFromURL(imageUrl: imageUrl, fbUserId: currentUserFacebookId, completion: { (image) in
                
                if let userImage = image {
                    CacheService.cacheService.cacheDownloadedProfileImage(image: userImage, fbUserId: currentUserFacebookId)
                    
                    self.collectionView.reloadData()
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Get the unique conversation id between the user and recipient from Firebase.
        self.fetchConversationIdFromFirebase() { (conversationKey : String?) -> () in
            
            if (conversationKey != nil) {
                // Add Firebase listner to fetch new letters if any data changes at Firebase reference node occurs.
                self.fetchLettersFromFirebaseListener()
            } else {
                self.conversationId = ""
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.askForCameraAuthorization { (didGrantAccess) in
            
            if (didGrantAccess == false) {
                self.handleDeniedCameraPermission()
            }
        }
    }
    
    
    // MARK:
    // MARK: Action Methods
    
    func addButtonClicked(sender: UIBarButtonItem) {
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "WriteLetterViewController") as? WriteLetterViewController  {
            controller.recipientContactProperties = self.recipientContactProperties
            controller.hidesBottomBarWhenPushed = true
            controller.isWritingNewLetter = true
            controller.conversationId = self.conversationId
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    // MARK:
    // MARK: Data Loading
    
    private func fetchConversationIdFromFirebase(completion: @escaping (String?) -> ()) {
        
        let facebookUserId = self.recipientContactProperties.facebookUserId
        let usersConversationReference = DataService.dataService.userConversationsReference.child(facebookUserId).child("conversationId")
        
        usersConversationReference.observeSingleEvent(of: .value, with: { snapshot in
            if (snapshot.value == nil) {
                completion(nil)
            }
            self.conversationId = snapshot.value as? String
            completion(self.conversationId)
        })
    }
    
    private func fetchLettersFromFirebaseListener() {
        
        let lettersConversationReference = DataService.dataService.lettersDatabaseReference.child(self.conversationId)
        lettersConversationReference.observe(FIRDataEventType.value) { (snapshot: FIRDataSnapshot) in
            
            if let letterSnap = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                self.allLettersArray = []
                
                for contentSnap in letterSnap {
                    
                    let emotionSnap = contentSnap.childSnapshot(forPath: "emotionData")
                    let emotionDataArray = self.parseEmotionData(firebaseSnap: emotionSnap)
                    
                    let letterDataSnap = contentSnap.childSnapshot(forPath: "letterData")
                    if let letterDict = letterDataSnap.value as? Dictionary<String, String> {
                        
                        let letter = Letter(date: letterDict["date"],
                                            fullLetterText: letterDict["letterText"],
                                            recieverId: letterDict["receiver"],
                                            senderId: letterDict["sender"],
                                            letterUniqueId: contentSnap.key,
                                            isRead: letterDict["isLetterRead"],
                                            emotionDataArray: emotionDataArray)
                        
                        self.allLettersArray.append(letter)
                    }

                }
            }
            
            self.allLettersArray = self.allLettersArray.reversed()
            self.collectionView.reloadData()
        }
    }
    
    private func parseEmotionData(firebaseSnap: FIRDataSnapshot) -> [EmotionDataObject] {
        
        var emotionDataObject: [EmotionDataObject] = []
        
        if let emotionSnaps = firebaseSnap.children.allObjects as? [FIRDataSnapshot] {
            
            for contentSnap in emotionSnaps {
                
                if let emotionDict = contentSnap.value as? Dictionary<String, String> {
                    
                    let captureUnit: Int! = (Int(contentSnap.key) != nil) ? Int(contentSnap.key): 0
                    let emotionObject = EmotionDataObject(emotionScores: emotionDict, captureOrderUnit: captureUnit)
                    
                    emotionDataObject.append(emotionObject)
                }
            }
        }
        
        return emotionDataObject
    }
    
    
    // MARK:
    // MARK: UICollectionViewDataSource Methods
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.allLettersArray.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllConversationsCollectionViewCell", for: indexPath) as? AllConversationsCollectionViewCell {
            
            let fbUserId = self.allLettersArray[indexPath.row].senderFbId
            var senderName = self.recipientContactProperties.name
            
            if (fbUserId != self.recipientContactProperties.facebookUserId) {
                // If the letters is sent by the user himself.
               senderName = NSLocalizedString("You", comment: "")
            }
            
            cell.configureCellWithLetter(letterObject: self.allLettersArray[indexPath.row], senderName: senderName)
            
            return cell
        }
        
        return AllConversationsCollectionViewCell()
    }
    
    
    // MARK:
    // MARK: UICollectionViewDelegate Methods
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let conversationCell = cell as? AllConversationsCollectionViewCell {
            
            let fbUserId = self.allLettersArray[indexPath.row].senderFbId
            
            if let image = CacheService.cacheService.fetchUserImageFromCache(fbUserId: fbUserId) {
                conversationCell.configureCellWithUserImage(userImage: image)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 40.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let cell = self.collectionView.cellForItem(at: indexPath as IndexPath) as? AllConversationsCollectionViewCell {
            return CGSize(width: collectionView.bounds.size.width, height: cell.getEstimatedCellHeight());
        }
        
        return CGSize(width: collectionView.bounds.size.width, height: 140.0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "WriteLetterViewController") as? WriteLetterViewController  {
            controller.currentLetterObject = self.allLettersArray[indexPath.row];
            controller.hidesBottomBarWhenPushed = true
            controller.isWritingNewLetter = false
            controller.conversationId = self.conversationId
            controller.recipientContactProperties = self.recipientContactProperties
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    // MARK:
    // MARK: Private Helper Methods
    
    private func askForCameraAuthorization(completion: @escaping (Bool) -> ()) {
        
        let accessStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if (accessStatus == .authorized) {
            // Do nothing.
            completion(true)
        }
        
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { (didGrantAccess) in
            completion(didGrantAccess)
        }
    }
    
    private func handleDeniedCameraPermission() {
        
        let title = NSLocalizedString("Go to Settings -> Alpa -> Camera to give access", comment: "")
        let message = NSLocalizedString("Access to camera is needed to analyze your emotions when you read a new message.", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (action) in
            
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
