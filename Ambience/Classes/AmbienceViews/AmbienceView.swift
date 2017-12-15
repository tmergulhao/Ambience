//
//  AmbienceView.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 21/10/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

open class AmbienceView : UIView {
    
    @IBInspectable public var contrastColor : UIColor?
    @IBInspectable public var invertColor : UIColor?
    @IBInspectable public var regularColor : UIColor?
    
    open override func didMoveToSuperview() {
        Ambience.add(listener: self)
    }
    
    deinit {
        Ambience.remove(listener: self)
    }
}

extension AmbienceView : AmbienceListener {
    
    @objc open func ambience(_ notification : Notification) {
        
        guard let currentState = notification.userInfo?["currentState"] as? AmbienceState else { return }
        
        UIView.animate(withDuration: 1) {
            self.backgroundColor = {
                switch currentState {
                case .contrast: return self.contrastColor
                case .invert: return self.invertColor
                case .regular: return self.regularColor
                }
                }() ?? self.backgroundColor
        }
    }
}
