//
//  UILabel+Ambience.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 21/10/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

extension UILabel {
    
    @IBInspectable public var textColorContrast : UIColor? {
        get {
            if let value = objc_getAssociatedObject(self, &KeyValues.contrast.textColor) as? UIColor {
                return value
            }
            
            self.textColorContrast = self.textColorRegular
            
            return self.textColorContrast
        }
        set { objc_setAssociatedObject(self, &KeyValues.contrast.textColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    @IBInspectable public var textColorInvert : UIColor? {
        get {
            if let value = objc_getAssociatedObject(self, &KeyValues.invert.textColor) as? UIColor {
                return value
            }
            
            self.textColorInvert = self.textColorRegular
            
            return self.textColorInvert
        }
        set { objc_setAssociatedObject(self, &KeyValues.invert.textColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public var textColorRegular : UIColor? {
        get {
            if let value = objc_getAssociatedObject(self, &KeyValues.regular.textColor) as? UIColor {
                return value
            }
            
            self.textColorRegular = self.textColor ?? .black
            
            return self.textColorRegular
        }
        set { objc_setAssociatedObject(self, &KeyValues.regular.textColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    override open func ambience(_ notification : Notification) {
        
        super.ambience(notification)
        
        _ = self.textColorRegular
        
        guard let currentState = notification.userInfo?["currentState"] as? AmbienceState else { return }
        
        if let animated = notification.userInfo?["animated"] as? Bool, animated == false {
            
            self.textColor = {
                switch currentState {
                case .contrast: return self.textColorContrast
                case .invert: return self.textColorInvert
                case .regular: return self.textColorRegular
                }
                }() ?? self.textColor
            
        } else {
            
            UIView.animate(withDuration: 1) {
                self.textColor = {
                    switch currentState {
                    case .contrast: return self.textColorContrast
                    case .invert: return self.textColorInvert
                    case .regular: return self.textColorRegular
                    }
                    }() ?? self.textColor
            }
        }
    }
}
