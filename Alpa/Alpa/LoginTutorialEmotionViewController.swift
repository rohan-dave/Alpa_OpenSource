//
//  LoginTutorialEmotionViewController.swift
//  Alpa
//
//  Created by ROHAN DAVE on 15/04/17.
//  Copyright © 2017 Rohan Dave. All rights reserved.
//

import UIKit



class LoginTutorialEmotionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    // MARK:
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tutorialLabel: UILabel!
    
    private var emotionDataTypes: [EmotionType] = []
    private var emotionScore: Float = 0.75
    private var emotionCaptureNumber: Int = 1
    
    
    // MARK:
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        let tutorialText = "Simply read a message to convey your emotions"
        self.tutorialLabel.text = NSLocalizedString(tutorialText, comment: "")
        
        // TableView Setup
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionHeaderHeight = 40.0
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = UIColor.clear
        
        self.createTableData()
        self.tableView.reloadData()
    }
    
    
    // MARK:
    // MARK: UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.emotionDataTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (self.emotionDataTypes.count == 0) {
            return nil
        }
        
        if let headerView = Bundle.main.loadNibNamed("EmotionHeaderView", owner: self, options: nil)?.first as? EmotionHeaderView {
            
            let type = self.emotionDataTypes[section]
            let name = self.emotionNameForType(type: type)
            headerView.configureHeaderView(titleLabelText: name, emotionType: type)
            
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EmotionalDataTableViewCell", for: indexPath) as? EmotionalDataTableViewCell {
            
            cell.configureEmotionCell(emotionCaptureNumber: emotionCaptureNumber, emotionScore: emotionScore, emotionType: self.emotionDataTypes[indexPath.section])
            
            self.emotionCaptureNumber += 1
            if (self.emotionDataTypes[indexPath.section] == .happiness) {
                self.emotionScore = 0.50
            }
            else {
                self.emotionScore = 0.60
            }
            
            return cell
        }
        
        return EmotionalDataTableViewCell()
    }
    
    
    // MARK:
    // MARK: Private Helper Methods
    
    private func createTableData() {
        
        emotionDataTypes.append(.happiness)
        emotionDataTypes.append(.surprise)
        emotionDataTypes.append(.neutral)
    }
    
    private func emotionNameForType(type: EmotionType) -> String {
        
        if (type == .happiness) {
            return NSLocalizedString("Happy", comment: "")
        }
        
        if (type == .surprise) {
            return NSLocalizedString("Surprised", comment: "")
        }
        
        if (type == .neutral) {
            return NSLocalizedString("Neutral", comment: "")
        }
        
        return ""
    }
        
}
