//
//  STAmbience.swift
//  STAmbience
//
//  Created by Tiago Mergulhão on 21/02/15.
//  Copyright (c) 2015 Tiago Mergulhão. All rights reserved.
//

import UIKit

public typealias Brightness = CGFloat
internal typealias BrightnessRange = (lower : Brightness, upper : Brightness)

public class Ambience {
	
    static var shared : Ambience = Ambience()
	
	internal var previousState : AmbienceState?
	internal var currentState : AmbienceState = .Regular {
        willSet {
            previousState = currentState
        }
        didSet {
            listeners.forEach {
                $0.ambience(didChangeFrom: previousState, to: currentState)
            }
        }
	}
	internal var constraints : AmbienceConstraints = [
		.Invert(upper: 0.10),
		.Regular(lower: 0.05, upper: 0.95),
		.Contrast(lower: 0.90)
	] {
		didSet {
			checkBrightnessValue()
		}
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

        if let firstState = acceptableStates.first, !acceptableStates.contains(currentState) {
            currentState = firstState
        }
	}
	internal func checkBrightnessValue () {
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
    
    var listeners = Array<AmbienceListener>()
    
    public class func insert (_ listener : AmbienceListener) {
        Ambience.shared.listeners.append(listener)
    }
    public class func remove (_ listener : AmbienceListener) {
        //Ambience.shared.listeners
    }
	
	private init () {
		
        NotificationCenter.default.addObserver(self,
            selector: #selector(brightnessDidChange),
			name: NSNotification.Name.UIScreenBrightnessDidChange,
			object: nil)
		
		checkBrightnessValue()
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
