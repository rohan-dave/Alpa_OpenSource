//
//  EmotionHeaderView.swift
//  Alpa
//
//  Created by ROHAN DAVE on 09/04/17.
//  Copyright © 2017 Rohan Dave. All rights reserved.
//

import UIKit

class EmotionHeaderView: UIView {

    
    @IBOutlet weak var headerTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
    }
    
    func configureHeaderView(titleLabelText: String?, emotionType: EmotionType?) {
        
        if let title = titleLabelText, let type = emotionType {
            let emoji = self.emojiForEmotionType(emotionType: type)
            self.headerTitleLabel.text = title + " " + emoji
        }
    }
    
    private func emojiForEmotionType(emotionType: EmotionType) -> String {
        
        switch emotionType {
        case .happiness:
            return "😄"
            
        case .neutral:
            return "😌"
            
        case .surprise:
            return "😮"
            
        case .sadness:
            return "😔"
            
        case .anger:
            return "😠"
            
        case .fear:
            return "😰"
            
        case .disgust:
            return "😫"
            
        case .contempt:
            return "😒"
        }
    }
}
