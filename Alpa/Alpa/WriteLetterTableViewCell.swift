//
//  WriteLetterTableViewCell.swift
//  Alpa
//
//  Created by ROHAN DAVE on 01/08/16.
//  Copyright © 2016 Rohan Dave. All rights reserved.
//

import UIKit


class WriteLetterTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var letterDateLabel: UILabel!
    @IBOutlet weak var letterTextView: UITextView!
    
    
    override func awakeFromNib() {
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.cornerRadius = 5.0
        
        self.contactImageView.layer.cornerRadius = 25.0
        self.contactImageView.layer.masksToBounds = true
        self.contactImageView.layer.borderWidth = 1.0
        self.contactImageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setUserImage(image: UIImage) {
        
        let userImage = image.af_imageRoundedIntoCircle()
        self.contactImageView.image = userImage
    }
    
    func configureNewLetterCell(letterText:String!, letterDate: NSDate!) {
        self.letterTextView.text = letterText
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        self.letterDateLabel.text = dateFormatter.string(from: letterDate as Date)
    }
    
    func configureCellToDisplayLetter(letterObject: Letter!) {
        self.letterTextView.text = letterObject.letterText
        self.letterDateLabel.text = letterObject.letterDate
    }
}
