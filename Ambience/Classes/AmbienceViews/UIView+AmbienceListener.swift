//
//  UIView+AmbienceListener.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 15/12/17.
//

import UIKit

extension UIView {
    
//    static var questions : Array<Dictionary<String,AnyObject>> = {
//        
//        guard let path = Bundle(for: Ambience.self).path(forResource: "Defaults", ofType: "plist"),
//            let dictionary = NSDictionary(contentsOfFile: path) as? Dictionary<String,AnyObject>,
//            let questions = dictionary["questions"] as? Array<Dictionary<String,AnyObject>> else {
//                fatalError("Bundle.main.path(forResource: \"SelectionItems\", ofType: \"plist\")")
//        }
//        
//        return questions
//    }()
    
    @IBInspectable public var contrastColor : UIColor? {
        get {
            if let manager = objc_getAssociatedObject(self, &KeyValues.contrast.backgroundColor) as? UIColor {
                return manager
            }
            
            let bundle = Bundle(for: Ambience.self)
            self.contrastColor = UIColor(named: String(describing:type(of: self)) + "/contrast", in: bundle, compatibleWith: nil)
            return self.contrastColor
        }
        set { objc_setAssociatedObject(self, &KeyValues.contrast.backgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    @IBInspectable public var invertColor : UIColor? {
        get {
            if let manager = objc_getAssociatedObject(self, &KeyValues.invert.backgroundColor) as? UIColor {
                return manager
            }
            
            let bundle = Bundle(for: Ambience.self)
            self.invertColor = UIColor(named: String(describing:type(of: self)) + "/invert", in: bundle, compatibleWith: nil)
            return self.invertColor
        }
        set { objc_setAssociatedObject(self, &KeyValues.invert.backgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    @IBInspectable public var regularColor : UIColor? {
        get {
            if let manager = objc_getAssociatedObject(self, &KeyValues.regular.backgroundColor) as? UIColor {
                return manager
            }
            
            let bundle = Bundle(for: Ambience.self)
            self.regularColor = UIColor(named: String(describing:type(of: self)) + "/regular", in: bundle, compatibleWith: nil)
            return self.regularColor
        }
        set { objc_setAssociatedObject(self, &KeyValues.regular.backgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public override func ambience(_ notification: Notification) {
        
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
