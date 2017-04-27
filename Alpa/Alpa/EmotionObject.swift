//
//  EmotionObject.swift
//  Alpa
//
//  Created by ROHAN DAVE on 09/04/17.
//  Copyright © 2017 Rohan Dave. All rights reserved.
//

import Foundation



class EmotionObject {
    
    var emotionScore: Float = 0
    var emotionName: String
    var emotionType: EmotionType
    var emotionCaptureNumber: Int
    
    init(typeOfEmotion: EmotionType, emotionDataObject: EmotionDataObject) {
        
        self.emotionCaptureNumber = emotionDataObject.captureOrder
        self.emotionType = typeOfEmotion
        
        switch typeOfEmotion {
        case .happiness:
            self.emotionName = NSLocalizedString("Happy", comment: "")
            self.emotionScore = Float(emotionDataObject.happiness)
            break
            
        case .neutral:
            self.emotionName = NSLocalizedString("Neutral", comment: "")
            self.emotionScore = Float(emotionDataObject.neutral)
            break
            
        case .surprise:
            self.emotionName = NSLocalizedString("Surprised", comment: "")
            self.emotionScore = Float(emotionDataObject.surprise)
            break
            
        case .sadness:
            self.emotionName = NSLocalizedString("Sad", comment: "")
            self.emotionScore = Float(emotionDataObject.sadness)
            break
            
        case .anger:
            self.emotionName = NSLocalizedString("Angry", comment: "")
            self.emotionScore = Float(emotionDataObject.anger)
            break
            
        case .fear:
            self.emotionName = NSLocalizedString("Feared", comment: "")
            self.emotionScore = Float(emotionDataObject.fear)
            break
            
        case .disgust:
            self.emotionName = NSLocalizedString("Disgusted", comment: "")
            self.emotionScore = Float(emotionDataObject.disgust)
            break
            
        case .contempt:
            self.emotionName = NSLocalizedString("Contempt", comment: "")
            self.emotionScore = Float(emotionDataObject.contempt)
            break
        }
    }
    
    func shouldIncludeEmotionInData() -> Bool {
        
        return ((self.emotionScore - 0.0099) > 0)
    }
}

