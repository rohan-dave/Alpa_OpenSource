//
//  ProfileTableViewCell.swift
//  Alpa
//
//  Created by ROHAN DAVE on 10/04/17.
//  Copyright © 2017 Rohan Dave. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    
    // MARK:
    // MARK: Properties
    
    @IBOutlet weak var userPictureImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    // MARK:
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        
        // Picture Image View Setup
        self.userPictureImageView.layer.cornerRadius = self.userPictureImageView.bounds.size.width / 2.0
        self.userPictureImageView.layer.masksToBounds = true
        self.userPictureImageView.layer.borderWidth = 1.0
        self.userPictureImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    
    // MARK:
    // MARK: Public Configuration Methods
    
    func configureProfileCell(userNameText: String) {
        
        self.userNameLabel.text = userNameText
    }
    
    func configureCellWithUserImage(userImage: UIImage!) {
        
        let circularImage = userImage.af_imageRoundedIntoCircle()
        self.userPictureImageView.image = circularImage
    }

}
