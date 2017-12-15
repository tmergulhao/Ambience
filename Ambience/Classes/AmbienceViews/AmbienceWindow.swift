//
//  AmbienceWindow.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 21/10/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

public class AmbienceWindow : UIWindow {
    
    public var contrastColor : UIColor?
    public var invertColor : UIColor?
    public var regularColor : UIColor?
    
    public convenience init (contrast contrastColor : UIColor, invert invertColor : UIColor, regular regularColor : UIColor, frame : CGRect) {
        self.init(frame: frame)
        self.contrastColor = contrastColor
        self.invertColor = invertColor
        self.regularColor = regularColor
        
        Ambience.add(listener: self)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Ambience.add(listener: self)
    }
    
    deinit {
        Ambience.remove(listener: self)
    }
}

extension AmbienceWindow : AmbienceListener {
    
    @objc public func ambience(_ notification : Notification) {
        
        guard let currentState = notification.userInfo?["currentState"] as? AmbienceState else { return }
        
        UIView.animate(withDuration: 1) {
            self.backgroundColor = {
                switch currentState {
                case .contrast: return self.contrastColor
                case .invert: return self.invertColor
                case .regular: return self.regularColor
                }
            }()
        }
    }
}
