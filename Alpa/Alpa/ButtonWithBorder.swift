//
//  ButtonWithBorder.swift
//  Alpa
//
//  Created by ROHAN DAVE on 24/07/16.
//  Copyright © 2016 Rohan Dave. All rights reserved.
//

import UIKit


class ButtonWithBorder: UIButton {
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // Border Setup
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.black.cgColor
        contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        
        // Rounded Edges
        self.layer.cornerRadius = self.bounds.size.height / 2;
        self.layer.masksToBounds = true
        
        // Font
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
    }
    
    func customBorderColor(color: UIColor!) {
        
        layer.borderColor = color.cgColor
    }
}
