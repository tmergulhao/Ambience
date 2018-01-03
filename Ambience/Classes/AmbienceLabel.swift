//
//  AmbienceLabel.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 03/01/2018.
//

import UIKit

public class AmbienceLabel : UILabel {
    
    override public func ambience(_ notification: Notification) {
        
        super.ambience(notification)
        
        guard let currentState = notification.userInfo?["currentState"] as? AmbienceState else { return }
        
        text = {
            
            let aditionalText = Ambience.forcedState == nil ? "" : " (Forced)"
            
            switch currentState {
            case .contrast: return "Contrast" + aditionalText
            case .invert: return "Invert" + aditionalText
            case .regular: return "Regular" + aditionalText
            }
        }()
    }
}
