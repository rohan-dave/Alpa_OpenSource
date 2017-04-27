//
//  EmotionDataObject.swift
//  Alpa
//
//  Created by ROHAN DAVE on 06/04/17.
//  Copyright © 2017 Rohan Dave. All rights reserved.
//

import Foundation

import RealmSwift



class EmotionDataObject: Object {
    
    var captureOrder: Int = 0
    var anger: Double = 0.0
    var contempt: Double = 0.0
    var disgust: Double = 0.0
    var fear: Double = 0.0
    var happiness: Double = 0.0
    var neutral: Double = 0.0
    var sadness: Double = 0.0
    var surprise: Double = 0.0
    
    convenience init(emotionScores: [String: String], captureOrderUnit: Int) {
        
        self.init()
        
        captureOrder = captureOrderUnit
        anger = self.getDoubleFromString(emotionScore: emotionScores["anger"])
        contempt = self.getDoubleFromString(emotionScore: emotionScores["contempt"])
        disgust = self.getDoubleFromString(emotionScore: emotionScores["disgust"])
        fear = self.getDoubleFromString(emotionScore: emotionScores["fear"])
        happiness = self.getDoubleFromString(emotionScore: emotionScores["happiness"])
        neutral = self.getDoubleFromString(emotionScore: emotionScores["neutral"])
        sadness = self.getDoubleFromString(emotionScore: emotionScores["sadness"])
        surprise = self.getDoubleFromString(emotionScore: emotionScores["surprise"])
    }
    
    private func getDoubleFromString(emotionScore: String?) -> Double! {
        
        if (emotionScore == nil || (emotionScore?.isEmpty == true)) {
            return 0.0
        }
        
        return Double(emotionScore!)
    }
}
