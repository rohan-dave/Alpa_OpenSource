//
//  FacebookFriendProperties.swift
//  Alpa
//
//  Created by ROHAN DAVE on 14/08/16.
//  Copyright © 2016 Rohan Dave. All rights reserved.
//

import Foundation

import RealmSwift

class FacebookFriendProperties: Object {
    
    dynamic var name: String = ""
    dynamic var email: String = ""
    dynamic var facebookUserId: String = ""
    dynamic var profilePictureUrl: String = ""
    
    convenience init(propertiesDictionary: Dictionary<String, String>) {
        
        self.init()
        
        self.name = propertiesDictionary["name"]!
        self.email = propertiesDictionary["email"]!
        self.facebookUserId = propertiesDictionary["facebookUserId"]!
        
        if let url: String = propertiesDictionary["profilePictureUrl"] {
            self.profilePictureUrl = url
        }
    }
    
    func isEqualToObject(friendPropertiesObject: FacebookFriendProperties) -> Bool {
        if (self.email == friendPropertiesObject.email && self.name == friendPropertiesObject.name && self.facebookUserId == friendPropertiesObject.facebookUserId && self.profilePictureUrl == friendPropertiesObject.profilePictureUrl) {
            return true
        }
        
        return false
    }
}
