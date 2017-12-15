//
//  AmbienceLabel.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 21/10/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

extension UILabel {
    
    @objc public override func normallyListensToAmbience () -> Bool { return true }
    
    public override func ambience(_ notification : Notification) {
        
        guard let currentState = notification.userInfo?["currentState"] as? AmbienceState else { return }
        
        UIView.animate(withDuration: 1) {
            self.textColor = {
                switch currentState {
                case .contrast: return self.contrastColor
                case .invert: return self.invertColor
                case .regular: return self.regularColor
                }
                }() ?? self.textColor
        }
    }
}
