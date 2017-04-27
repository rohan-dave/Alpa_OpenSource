//
//  RecentLettersTableViewCell.swift
//  Alpa
//
//  Created by ROHAN DAVE on 31/07/16.
//  Copyright © 2016 Rohan Dave. All rights reserved.
//

import UIKit


class RecentLettersTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var recentLetterLabel: UILabel!
    @IBOutlet weak var contactNameLabel: UILabel!
    var profileImageUrl: String!
    
    
    override func awakeFromNib() {
        
        self.backgroundColor = UIColor.clear
        self.contactNameLabel.text = ""
        self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.bounds.size.width / 2.0
        self.profilePictureImageView.layer.masksToBounds = true
        self.profilePictureImageView.layer.borderWidth = 1.0
        self.profilePictureImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    func configureCell(name: String!, profileImageUrl: String!, profileImage: UIImage?, lastLetterBriefLine: String!) {
        
        self.contactNameLabel.text = name
        self.recentLetterLabel.text = lastLetterBriefLine
        self.profileImageUrl = profileImageUrl
        self.profilePictureImageView.image = UIImage(named: "main_logo_icon")
    }
    
    func configureCellWithUserImage(userImage: UIImage!) {
        
        let circularImage = userImage.af_imageRoundedIntoCircle()
        self.profilePictureImageView.image = circularImage
    }
}
