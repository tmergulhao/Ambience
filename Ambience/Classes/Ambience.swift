//
//  Ambience.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 21/02/15.
//  Copyright (c) 2015 Tiago Mergulhão. All rights reserved.
//

import UIKit

public typealias Brightness = CGFloat
internal typealias BrightnessRange = (lower : Brightness, upper : Brightness)

public extension Notification.Name {
    public static let STAmbienceDidChange = Notification.Name("STAmbienceDidChangeNotification")
}

public class Ambience {
    
    public static var shared : Ambience = Ambience()
    
    static var forcedPersistence = Default<String>(key: "STAmbienceForcedState")
    
    public static var forcedState : AmbienceState? = nil {
        didSet {
            if let forcedState = self.forcedState {
                self.currentState = forcedState
            } else {
                self.shared.checkBrightnessValue()
                let currentState = self.currentState
                self.currentState = currentState
            }
            
            forcedPersistence « forcedState?.rawValue
        }
    }
    
    public static var previousState : AmbienceState = .regular
    public static var currentState : AmbienceState = .regular {
        willSet {
            previousState = currentState
        }
        didSet {
            let notification : Notification = Notification(name: Notification.Name.STAmbienceDidChange, object: nil, userInfo: ["previousState" : previousState, "currentState": currentState])
            
            NotificationCenter.default.post(notification)
        }
    }
    internal var constraints : AmbienceConstraints = [
        .invert(upper: 0.10),
        .regular(lower: 0.05, upper: 0.95),
        .contrast(lower: 0.90)
        ] {
        didSet {
            checkBrightnessValue()
        }
    }
    
    public static func reinstateAmbience (for listener : AmbienceListener) {
        
        let notification : Notification = Notification(name: Notification.Name.STAmbienceDidChange, object: nil, userInfo: ["previousState" : previousState, "currentState": currentState])
        
        listener.ambience(notification)
    }
    
    internal func processConstraints (forBrightness brightness : Brightness) {
        
        let acceptableStates : AmbienceStates = constraints.filter{
            $0.rangeFunctor(brightness)
            }.map {
                $0.state
            }.reduce(AmbienceStates()) {
                (set : AmbienceStates, item : AmbienceState) -> AmbienceStates in
                return set.union([item])
        }
        
        if let firstState = acceptableStates.first, !acceptableStates.contains(Ambience.currentState) {
            Ambience.currentState = firstState
        }
    }
    internal func checkBrightnessValue () {
        
        if Ambience.forcedState != nil { return }

        processConstraints(forBrightness : UIScreen.main.brightness)
    }
    
    @objc public func brightnessDidChange (notification : NSNotification) {
        
        checkBrightnessValue()
    }
    
    public func insert ( _ constraint : AmbienceConstraint ) {
        var newSet = AmbienceConstraints()
        newSet.insert(constraint)
        newSet.formUnion(constraints)
        self.constraints = newSet
    }
    
    internal init () {
        
        UIView.classInit
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(brightnessDidChange),
            name: UIScreen.brightnessDidChangeNotification,
            object: nil)
        
        if let previousState = Ambience.forcedPersistence.value, let forcedState = AmbienceState(rawValue: previousState) {
            Ambience.forcedState = forcedState
        } else {
            checkBrightnessValue()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension Ambience {
    public func insert ( _ constraints : AmbienceConstraints ) {
        constraints.forEach {
            [weak self] in
            self?.insert($0)
        }
    }
}
