//
//  LoginTutorialLetterViewController.swift
//  Alpa
//
//  Created by ROHAN DAVE on 15/04/17.
//  Copyright © 2017 Rohan Dave. All rights reserved.
//

import UIKit



class LoginTutorialLetterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    // MARK:
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tutorialLabel: UILabel!
    
    
    // MARK:
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        let tutorial = "Designed to immerse you in the art of great conversations"
        self.tutorialLabel.text = NSLocalizedString(tutorial, comment: "")
        
        // TableView Setup
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 70.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = UIColor.clear
    }
    
    
    // MARK:
    // MARK: UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WriteLetterTableViewCell", for: indexPath) as? WriteLetterTableViewCell {
            
            cell.letterTextView.text = self.getLetterTextForTutorial()
            cell.letterDateLabel.text = NSLocalizedString("April 8, 2016", comment: "")
            
            if let image = UIImage(named: "female_user_picture") {
                cell.setUserImage(image: image)
            }
            
            return cell
        }
        
        return WriteLetterTableViewCell()
    }
    
    
    // MARK:
    // MARK: UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    
    
    // MARK:
    // MARK: Private Helper Methods
    
    private func getLetterTextForTutorial() -> String {
        
        let text = "Dear Lisa,\n\nFor you are one, yet thousands in one.\nBirthing rocks to pebbles,\nwith undying love, dissolving all the rebels.\nClose if you listen and far if you go,\npatient if you stay and heart if you slow...\n\nLove,\nJoshua"
        
        return NSLocalizedString(text, comment: "")
    }
}
