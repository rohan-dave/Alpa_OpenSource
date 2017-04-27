//
//  LetterEmotionViewController.swift
//  Alpa
//
//  Created by ROHAN DAVE on 09/04/17.
//  Copyright © 2017 Rohan Dave. All rights reserved.
//

import UIKit



class LetterEmotionViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    
    // MARK:
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    var emotionData: [EmotionDataObject] = []
    var emotionTableData: [[EmotionObject]] = []
    
    // MARK: 
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupGradientBackground()
        
        // TableView Setup
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.estimatedSectionHeaderHeight = 40.0
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        // Data Setup
        self.createTableData()
        self.tableView.reloadData()
    }
    
    
    // MARK:
    // MARK: UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if (self.emotionTableData.count == 0) {
            // NO Data Section
            return 1
        }
        
        return self.emotionTableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.emotionTableData.count == 0) {
            return 1
        }
        
        return self.emotionTableData[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (self.emotionTableData.count == 0) {
            return nil
        }
        
        let firstEmotionObject = self.emotionTableData[section].first
        
        if let headerView = Bundle.main.loadNibNamed("EmotionHeaderView", owner: self, options: nil)?.first as? EmotionHeaderView {
            
            headerView.configureHeaderView(titleLabelText: firstEmotionObject?.emotionName, emotionType: firstEmotionObject?.emotionType)
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (self.emotionTableData.count == 0) {
            var noDataCell = tableView.dequeueReusableCell(withIdentifier: "noDataCell")
            if (noDataCell == nil) {
                noDataCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "noDataCell")
            }
            noDataCell?.textLabel?.text = NSLocalizedString("No emotions recored yet. Check back later.", comment: "")
            noDataCell?.textLabel?.font = UIFont.systemFont(ofSize: 13.0)
            noDataCell?.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            
            return (noDataCell != nil) ? noDataCell! : UITableViewCell()
        }
        
        if let emotionCell = tableView.dequeueReusableCell(withIdentifier: "EmotionalDataTableViewCell") as? EmotionalDataTableViewCell {
            
            let emotionObject = self.emotionTableData[indexPath.section][indexPath.row]
            emotionCell.configureEmotionCell(emotionCaptureNumber: emotionObject.emotionCaptureNumber, emotionScore: emotionObject.emotionScore, emotionType: emotionObject.emotionType)
            
            return emotionCell
        }
        
        return UITableViewCell()
    }
    
    
    // MARK:
    // MARK: UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK:
    // MARK: Private Helper Methods
    
    private func createTableData() {
        
        self.createEmotionObjectArray(emotionType: .happiness)
        self.createEmotionObjectArray(emotionType: .neutral)
        self.createEmotionObjectArray(emotionType: .surprise)
        self.createEmotionObjectArray(emotionType: .sadness)
        self.createEmotionObjectArray(emotionType: .anger)
        self.createEmotionObjectArray(emotionType: .fear)
        self.createEmotionObjectArray(emotionType: .disgust)
        self.createEmotionObjectArray(emotionType: .contempt)
    }
    
    private func createEmotionObjectArray(emotionType: EmotionType) {
        
        var emotionTypeArray: [EmotionObject] = []
        for emotion in emotionData {
            let emotionObject = EmotionObject(typeOfEmotion: emotionType, emotionDataObject: emotion)
            if (emotionObject.shouldIncludeEmotionInData() == true) {
                emotionTypeArray.append(emotionObject)
            }
        }
        
        if (emotionTypeArray.count > 0) {
            // Only append array which have at least one element
            self.emotionTableData.append(emotionTypeArray)
        }
    }
}
