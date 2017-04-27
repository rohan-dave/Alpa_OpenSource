//
//  FacebookFriendList.swift
//  Alpa
//
//  Created by ROHAN DAVE on 10/08/16.
//  Copyright © 2016 Rohan Dave. All rights reserved.
//

import Foundation

import SwiftyJSON
import RealmSwift


class FacebookFriendList: Object {
    
    var friendList = List<FacebookFriendProperties>()
    dynamic var totalNumberOfFriends: Int = 0
    dynamic var paging: PagingCursorDictionary? = PagingCursorDictionary()
    dynamic var isObjectForRecentContacts: String! = "false"
    
    convenience init(resultObject: JSON, isRecentContacts: String!) {
        
        self.init()
        
        if let friendsArray = resultObject["data"].array {
            for friend in friendsArray {
                let name = friend["name"].stringValue
                let email = friend["email"].stringValue
                let userId = friend["id"].stringValue
                let profilePictureUrl = friend["picture"]["data"]["url"].stringValue
                
                let friendObject = FacebookFriendProperties(propertiesDictionary:
                    ["name":name,
                    "email":email,
                    "facebookUserId":userId,
                    "profilePictureUrl":profilePictureUrl])
                
                self.friendList.append(friendObject)
            }
        }
        
        self.totalNumberOfFriends = resultObject["summary"].intValue
        
        let pagingCursors = resultObject["paging"]["cursors"]
        self.paging = PagingCursorDictionary(cursorObject: pagingCursors)
        
        self.isObjectForRecentContacts = isRecentContacts
    }
    
    override static func primaryKey() -> String? {
        return "isObjectForRecentContacts"
    }
}

class PagingCursorDictionary: Object {
    dynamic var after: String = ""
    dynamic var before: String = ""
    
    convenience init(cursorObject: JSON) {
        self.init()
        
        self.after = cursorObject["after"].stringValue
        self.before = cursorObject["before"].stringValue
    }
}
