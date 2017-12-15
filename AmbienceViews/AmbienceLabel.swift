//
//  AmbienceLabel.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 21/10/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

class AmbienceLabel : UILabel {
    
    @IBInspectable var contrastColor : UIColor?
    @IBInspectable var invertColor : UIColor?
    @IBInspectable var regularColor : UIColor?
    
    public override func didMoveToWindow() {
        Ambience.add(listener: self)
    }
    
    deinit {
        Ambience.remove(listener: self)
    }
}

extension AmbienceLabel : AmbienceListener {
    
    @objc public func ambience(_ notification : Notification) {
        
        guard let currentState = notification.userInfo?["currentState"] as? AmbienceState else { return }
        
        UIView.animate(withDuration: 1) {
            self.textColor = {
                switch currentState {
                case .Contrast: return self.contrastColor
                case .Invert: return self.invertColor
                case .Regular: return self.regularColor
                }
                }() ?? self.textColor
        }
    }
}
