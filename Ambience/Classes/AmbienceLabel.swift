//
//  AmbienceLabel.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 03/01/2018.
//

import UIKit

open class AmbienceLabel : UILabel {
    
    @IBInspectable var contrastLabel : String?
    @IBInspectable var invertLabel : String?
    @IBInspectable var regularLabel : String?
    @IBInspectable var autoLabel : String?
    
    override open func ambience(_ notification: Notification) {
        
        super.ambience(notification)
        
        guard let currentState = notification.userInfo?["currentState"] as? AmbienceState else { return }
        
        text = {
            
            let aditionalText = Ambience.forcedState == nil ? "" : " (Forced)"
            
            switch currentState {
            case .contrast:
                if let label = contrastLabel {
                    return label
                }
                return "Contrast" + aditionalText
            case .invert:
                if let label = invertLabel {
                    return label
                }
                return "Invert" + aditionalText
            case .regular:
                if let label = regularLabel {
                    return label
                }
                return "Regular" + aditionalText
            }
        }()
    }
}
