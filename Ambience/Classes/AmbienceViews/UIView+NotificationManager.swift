//
//  UIView+AmbienceListener.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 15/12/17.
//

import UIKit

fileprivate class NotificationManager {
    
    weak var observer : NSObject?
    
    init(observer : NSObject) {
        self.observer = observer
        
        Ambience.add(listener: observer)
    }
    
    deinit {
        if let observer = observer {
            Ambience.remove(listener: observer)
        }
    }
}

private var notificationManagerKey = "notificationManagerKey"

extension UIView {
    
    @objc public func normallyListensToAmbience () -> Bool { return false }
    
    @IBInspectable public var listensToAmbience : Bool {
        get {
            if let listensToAmbience = objc_getAssociatedObject(self, &KeyValues.listensToAmbience) as? Bool {
                return listensToAmbience
            }

            self.listensToAmbience = self.normallyListensToAmbience()
            return self.listensToAmbience
        }
        set { objc_setAssociatedObject(self, &KeyValues.listensToAmbience, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
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
    
    static let classInit: Void = {
        
        let originalSelector = #selector(didMoveToWindow)
        let swizzledSelector = #selector(swizzled_didMoveToWindow)
        swizzling(forClass: UIView.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()
    
    @objc func swizzled_didMoveToWindow() {
        
        // It's really common that ghost UIViews, namely _UILayoutGuides, that have no business being here pose a threat to this algorithm
        // To avoid such unfortunate series of events we choose to ask our guests to describe themselves by name or confirm their understanding
        // of the consequences of stating that, yes, they are interested in listening to Ambience.
        
        if listensToAmbience || String(describing:type(of: self)) == "UIView" {

            _ = self.notificationManager
        }
    }
}

extension NSObject : AmbienceListener {
    
    public func ambience(_ notification: Notification) { return }
}
