//
//  NSObject+NotificationManager.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 02/01/2018.
//

import UIKit

internal class NotificationManager {
    
    weak var observer : NSObject?
    
    init(observer : NSObject) {
        self.observer = observer
        
        Ambience.add(listener: observer)
    }
    
    deinit {
        
        // Needs to check if this ever get's called, ever.
        
        if let observer = observer {
            Ambience.remove(listener: observer)
        }
    }
}

private var notificationManagerKey = "notificationManagerKey"

internal extension NSObject {
    
    internal class func swizzling (forClass : AnyClass, originalSelector : Selector, swizzledSelector : Selector) {
        
        guard let originalMethod = class_getInstanceMethod(forClass, originalSelector) else { return }
        guard let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector) else { return }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}

extension NSObject {
    
    static let forbiddenNames : Set<String> = [
        "NSLayoutConstraint",
        "UICollectionViewFlowLayout",
        "_UILayoutGuide",
        "UILayoutGuide",
    ]
    
    static let earlyAdopters : Set<String> = [
        "UINavigationBar",
        "UITabBar"
    ]
    
    static let classInit : Void = {

        swizzling(forClass: UIView.self, originalSelector: #selector(awakeFromNib), swizzledSelector: #selector(swizzled_awakeFromNib))
    }()
    
    @objc open func swizzled_awakeFromNib () {
        
        let name = String(describing:type(of: self))
        
        guard !NSObject.forbiddenNames.contains(name) else { return }
        
        swizzled_awakeFromNib()
        
        if ambience {
            _ = notificationManager
        }
    }
}

extension NSObject {
    
    @IBInspectable public var ambience : Bool {
        get {
            if let ambience = objc_getAssociatedObject(self, &KeyValues.ambience) as? Bool {
                return ambience
            }
            
            self.ambience = false
            return self.ambience
        }
        set {
            
            let name = String(describing:type(of: self))
            
            if NSObject.earlyAdopters.contains(name) && newValue {
                _ = self.notificationManager
            }
            
            objc_setAssociatedObject(self, &KeyValues.ambience, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal var notificationManager: NotificationManager {
        get {
            if let manager = objc_getAssociatedObject(self, &KeyValues.notificationManager) as? NotificationManager {
                return manager
            }
            
            self.notificationManager = NotificationManager(observer: self)
            return self.notificationManager
        }
        set {
            objc_setAssociatedObject(self, &KeyValues.notificationManager, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension NSObject : AmbienceListener {
    
    @objc open func ambience(_ notification: Notification) {}
}
