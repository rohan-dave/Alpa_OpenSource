//
//  EmotionalDataTableViewCell.swift
//  Alpa
//
//  Created by ROHAN DAVE on 06/04/17.
//  Copyright © 2017 Rohan Dave. All rights reserved.
//

import UIKit

class EmotionalDataTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var emotionResponsePeriodLabel: UILabel!
    @IBOutlet weak var emotionProgressView: UIProgressView!
    
    
    // MARK:
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        // Rounded corners
        self.layer.cornerRadius = 6.0
        self.layer.masksToBounds = true
        
        // Progress View scaling and rounded corners
        self.emotionProgressView.layer.cornerRadius = 4.0
        self.emotionProgressView.layer.masksToBounds = true
        self.emotionProgressView.transform = CGAffineTransform(scaleX: 1, y: 4)
    }
    
    
    // MARK:
    // MARK: Public Configuration Methods
    
    func configureEmotionCell(emotionCaptureNumber: Int!, emotionScore: Float!, emotionType: EmotionType) {
        
        self.emotionResponsePeriodLabel.text = self.titleForLabel(captureNumber: emotionCaptureNumber)
        self.configureProgressView(emotionScore: emotionScore, emotionType: emotionType)
    }
    
    
    // MARK:
    // MARK: Private Helper Methods
    
    private func titleForLabel(captureNumber: Int!) -> String! {
        
        if (captureNumber == 1) {
            return NSLocalizedString("Beginning", comment: "")
        }
        else if (captureNumber == 2) {
            return NSLocalizedString("Mid-way", comment: "")
        }
        else if (captureNumber == 3) {
            return NSLocalizedString("Ending", comment: "")
        }
        
        return "Mid-way"
    }
    
    private func configureProgressView(emotionScore: Float!, emotionType: EmotionType) {
        
        self.emotionProgressView.progress = emotionScore
        
        switch emotionType {
        case .happiness:
            self.emotionProgressView.progressTintColor = UIColor.colorForHappiness()
            break
            
        case .neutral:
            self.emotionProgressView.progressTintColor = UIColor.colorForNeutral()
            break
            
        case .surprise:
            self.emotionProgressView.progressTintColor = UIColor.colorForSurprise()
            break
            
        case .sadness:
            self.emotionProgressView.progressTintColor = UIColor.colorForSadness()
            break
            
        case .anger:
            self.emotionProgressView.progressTintColor = UIColor.red
            break
            
        case .fear:
            self.emotionProgressView.progressTintColor = UIColor.colorForFear()
            break
        
        case.disgust:
            self.emotionProgressView.progressTintColor = UIColor.colorForDisgust()
            break
            
        case .contempt:
            self.emotionProgressView.progressTintColor = UIColor.colorForContempt()
            break
        }
        
    }
}
