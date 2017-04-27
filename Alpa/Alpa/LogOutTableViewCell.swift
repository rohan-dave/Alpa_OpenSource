//
//  LogOutTableViewCell.swift
//  Alpa
//
//  Created by ROHAN DAVE on 10/04/17.
//  Copyright © 2017 Rohan Dave. All rights reserved.
//

import UIKit



protocol LogOutTableViewCellDelegate {
    
    func didLogOutSuccesfully()
}



class LogOutTableViewCell: UITableViewCell {

    // MARK:
    // MARK: Properties
    
    @IBOutlet weak var logOutButton: UIButton!
    var delegate: LogOutTableViewCellDelegate?
    
    
    // MARK:
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.logOutButton.backgroundColor = UIColor.clear
        
        // Border and corners setup
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    // MARK:
    // MARK: Action Methods
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        
        if (AuthService.authService.logOutCurrentUser() == true) {
            self.delegate?.didLogOutSuccesfully()
        }
    }
    
    
}
