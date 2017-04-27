//
//  AllConversationsCollectionViewCell.swift
//  Alpa
//
//  Created by ROHAN DAVE on 31/07/16.
//  Copyright © 2016 Rohan Dave. All rights reserved.
//

import UIKit


class AllConversationsCollectionViewCell: UICollectionViewCell {
    
    
    // MARK:
    // MARK: Properties
    
    @IBOutlet weak private var shortLetterTextLabel: UILabel!
    @IBOutlet weak private var letterDateLabel: UILabel!
    @IBOutlet weak private var userImageView: UIImageView!
    @IBOutlet weak private var letterSenderFirstName: UILabel!
    
    
    // MARK:
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        
        // Border and corners setup
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        
        // User Image Configuration
        self.userImageView.layer.cornerRadius = self.userImageView.bounds.size.width / 2.0
        self.userImageView.layer.masksToBounds = true
        self.userImageView.layer.borderWidth = 1.0
        self.userImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    
    // MARK:
    // MARK: Public Configuration Methods
    
    func getEstimatedCellHeight() -> CGFloat {
        
        return 150.0
    }
    
    func configureCellWithLetter(letterObject: Letter, senderName: String?) {
        
        if (letterObject.isLetterRead == true || currentUserFacebookId == letterObject.senderFbId) {
            self.configureStyleForReadLetter()
        }
        else {
            self.configureStyleForUnreadLetter()
        }
        
        // Letter Label
        self.shortLetterTextLabel.text = letterObject.letterText
        // Date Label
        self.letterDateLabel.text = letterObject.letterDate
        // Name Label
        self.letterSenderFirstName.text = senderName?.components(separatedBy: " ").first
    }
    
    func configureCellWithUserImage(userImage: UIImage) {
        
        // Set User Image
        self.userImageView.image = userImage.af_imageRoundedIntoCircle()
    }
    
    
    // MARK:
    // MARK: Private Helper Methods
    
    private func configureStyleForUnreadLetter() {
        
        self.shortLetterTextLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        self.letterDateLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.letterSenderFirstName.font = UIFont.boldSystemFont(ofSize: 15.0)
    }
    
    private func configureStyleForReadLetter() {
        
        self.shortLetterTextLabel.font = UIFont(name: "Avenir-Book", size: 14.0)
        self.letterDateLabel.font = UIFont(name: "Avenir-LightOblique", size: 16.0)
        self.letterSenderFirstName.font = UIFont(name: "Avenir-Book", size: 15.0)
    }
}
