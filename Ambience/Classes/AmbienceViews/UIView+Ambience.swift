//
//  UIView+Ambience.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 15/12/17.
//

import UIKit

extension UIView {
    
    @IBInspectable public var contrastColor : UIColor? {
        get {
            if let value = objc_getAssociatedObject(self, &KeyValues.contrast.backgroundColor) as? UIColor {
                return value
            }
            
            self.contrastColor = self.regularColor
            
            return self.contrastColor
        }
        set { objc_setAssociatedObject(self, &KeyValues.contrast.backgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    @IBInspectable public var invertColor : UIColor? {
        get {
            if let value = objc_getAssociatedObject(self, &KeyValues.invert.backgroundColor) as? UIColor {
                return value
            }
            
            self.invertColor = self.regularColor
            
            return self.invertColor
        }
        set { objc_setAssociatedObject(self, &KeyValues.invert.backgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public var regularColor : UIColor? {
        get {
            if let value = objc_getAssociatedObject(self, &KeyValues.regular.backgroundColor) as? UIColor {
                return value
            }
            
            self.regularColor = self.backgroundColor ?? .clear

            return self.regularColor
        }
        set { objc_setAssociatedObject(self, &KeyValues.regular.backgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    @objc override open func ambience(_ notification: Notification) {
        
        super.ambience(notification)
        
        _ = self.regularColor
        
        guard let currentState = notification.userInfo?["currentState"] as? AmbienceState else { return }
        
        if let animated = notification.userInfo?["animated"] as? Bool, animated == false {
            
            self.backgroundColor = {
                switch currentState {
                case .contrast: return self.contrastColor
                case .invert: return self.invertColor
                case .regular: return self.regularColor
                }
            }() ?? self.backgroundColor
        
        } else {
            
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
}
