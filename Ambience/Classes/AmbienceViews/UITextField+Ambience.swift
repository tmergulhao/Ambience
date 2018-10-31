//
//  UITextField+Ambience.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 10/01/18.
//

import UIKit

extension UITextField {
    
    @IBInspectable public var textColorContrast : UIColor? {
        get {
            if let value = objc_getAssociatedObject(self, &KeyValues.contrast.textColor) as? UIColor {
                return value
            }
            
            self.textColorContrast = self.textColorRegular
            
            return self.contrastColor
        }
        set { objc_setAssociatedObject(self, &KeyValues.contrast.textColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    @IBInspectable public var textColorInvert : UIColor? {
        get {
            if let value = objc_getAssociatedObject(self, &KeyValues.invert.textColor) as? UIColor {
                return value
            }
            
            self.textColorInvert = self.textColorRegular
            
            return self.invertColor
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
            
            let color = {
                switch currentState {
                case .contrast: return self.textColorContrast
                case .invert: return self.textColorInvert
                case .regular: return self.textColorRegular
                }
            }() ?? textColor
            
            textColor = color
            
            if let string = attributedPlaceholder?.string, let color = textColor {
                attributedPlaceholder = NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor : color.withAlphaComponent(0.5)])
            }
            
        } else {
            
            UIView.animate(withDuration: 1) {
                
                let color = {
                    switch currentState {
                    case .contrast: return self.textColorContrast
                    case .invert: return self.textColorInvert
                    case .regular: return self.textColorRegular
                    }
                    }() ?? self.textColor
                
                self.textColor = color
                
                if let string = self.attributedPlaceholder?.string, let color = self.textColor {
                    self.attributedPlaceholder = NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor : color.withAlphaComponent(0.5)])
                }
            }
        }
    }
}
