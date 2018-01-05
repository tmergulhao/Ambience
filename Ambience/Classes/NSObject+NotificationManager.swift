//
//  NSObject+NotificationManager.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 02/01/2018.
//

import UIKit

fileprivate class NotificationManager {
    
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
            
            if newValue {
                _ = self.notificationManager
            }
            
            objc_setAssociatedObject(self, &KeyValues.ambience, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var notificationManager: NotificationManager {
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
