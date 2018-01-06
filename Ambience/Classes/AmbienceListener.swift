//
//  AmbienceListener.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 21/10/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

@objc public protocol AmbienceListener {
    
    @objc var ambience : Bool { get set }
    
    @objc func ambience (_ notification : Notification)
}

extension AmbienceListener {
    
    public func reinstateAmbience () {
        
        Ambience.reinstateAmbience(for: self)
    }
}

public extension Ambience {
    
    public class func add (listener : AmbienceListener) {
        
        _ = Ambience.shared
        
        NotificationCenter.default.addObserver(listener, selector: #selector(AmbienceListener.ambience(_:)), name: NSNotification.Name.STAmbienceDidChange, object: nil)
        
        let notification : Notification = Notification(name: Notification.Name.STAmbienceDidChange, object: nil, userInfo: ["previousState" : AmbienceState.regular, "currentState": currentState, "animated": false])
        
        listener.ambience(notification)
    }
    
    public class func remove (listener : AmbienceListener) {
        
        NotificationCenter.default.removeObserver(listener)
        
        let notification : Notification = Notification(name: Notification.Name.STAmbienceDidChange, object: nil, userInfo: ["previousState" : currentState, "currentState": AmbienceState.regular])
        
        listener.ambience(notification)
    }
}
