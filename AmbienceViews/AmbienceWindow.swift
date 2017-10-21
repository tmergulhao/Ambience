//
//  AmbienceWindow.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 21/10/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

public class AmbienceWindow : UIWindow, AmbienceListener {
    
    public var contrastColor : UIColor?
    public var invertColor : UIColor?
    public var regularColor : UIColor?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        Ambience.add(listener: self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Ambience.add(listener: self)
    }
    
    deinit {
        Ambience.remove(listener: self)
    }
    
    @objc public func ambience(_ notification : Notification) {
        
        guard let currentState = notification.userInfo?["currentState"] as? AmbienceState else { return }
        
        UIView.animate(withDuration: 1) {
            self.backgroundColor = {
                switch currentState {
                case .Contrast: return self.contrastColor
                case .Invert: return self.invertColor
                case .Regular: return self.regularColor
                }
            }()
        }
    }
}
