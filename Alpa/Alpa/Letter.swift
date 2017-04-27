//
//  Letter.swift
//  Alpa
//
//  Created by ROHAN DAVE on 14/08/16.
//  Copyright © 2016 Rohan Dave. All rights reserved.
//

import Foundation

import SwiftyJSON
import RealmSwift

class Letter: Object {
    
    var letterId: String = ""
    var isLetterRead: Bool = false
    var letterDate: String = ""
    var letterText: String = ""
    var timeStamp: String = ""
    var recieverFbId: String = ""
    var senderFbId: String = ""
    var reciever: FacebookFriendProperties? = FacebookFriendProperties()
    var sender: FacebookFriendProperties? = FacebookFriendProperties()
    var emotionData: List<EmotionDataObject> = List()
    
    // For creating new letter object to be sent to Firebase.
    convenience init(date: String!, fullLetterText: String!, recieverObject: FacebookFriendProperties!, senderObject: FacebookFriendProperties!) {
        
        self.init()
        
        isLetterRead = false
        letterDate = date
        letterText = fullLetterText
        reciever = recieverObject
        sender = senderObject
    }
    
    // For native use after fetching the data.
    convenience init(date: String?, fullLetterText: String?, recieverId: String?, senderId: String?, letterUniqueId: String?, isRead: String?, emotionDataArray: [EmotionDataObject]?) {
        
        self.init()
        
        letterId = (letterUniqueId != nil) ? letterUniqueId! : ""
        letterDate = (date != nil) ? date! : ""
        letterText = (fullLetterText != nil) ? fullLetterText! : ""
        recieverFbId = (recieverId != nil) ? recieverId! : ""
        senderFbId = (senderId != nil) ? senderId! : ""
        
        let hasRead = (isRead != nil) ? isRead! : ""
        
        if let read = Bool(hasRead) {
            isLetterRead = read
        } else {
            isLetterRead = false
        }
        
        // Form the List of EmotionDataObject
        if (emotionDataArray != nil) {
            for emotion in emotionDataArray! {
                emotionData.append(emotion)
            }

        }
    }
}
