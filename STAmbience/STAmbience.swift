//
//  STAmbience.swift
//  STAmbience
//
//  Created by Tiago Mergulhão on 21/02/15.
//  Copyright (c) 2015 Tiago Mergulhão. All rights reserved.
//

import UIKit

public func ==(lhs: AmbienceConstraint, rhs: AmbienceConstraint) -> Bool {
	return lhs.hashValue == rhs.hashValue
}
public func <(lhs: AmbienceConstraint, rhs: AmbienceConstraint) -> Bool {
	return lhs.hashValue < rhs.hashValue
}

public typealias Brightness = CGFloat
internal typealias BrightnessRange = (lower : Brightness, upper : Brightness)

public typealias AmbienceConstraints = Set<AmbienceConstraint>
internal typealias AmbienceStates = Set<AmbienceState>

public enum AmbienceState : String {
	case Invert = "invert"
	case Regular = "regular"
	case Contrast = "contrast"
}

public enum AmbienceConstraint : Hashable, Comparable, CustomStringConvertible {
	case Invert(upper : Brightness)
	case Regular(lower : Brightness, upper : Brightness)
	case Contrast(lower : Brightness)
	
	public var description : String {
        switch self {
        case .Invert(let upper): return "Invert<\(upper)>"
        case .Regular(let lower, let upper): return "Invert<\(lower), \(upper)>"
        case .Contrast(let lower): return "Contrast<\(lower)>"
        }
	}
	
	public var state : AmbienceState {
		switch self {
		case .Invert:	return AmbienceState.Invert
		case .Regular:	return AmbienceState.Regular
		case .Contrast: return AmbienceState.Contrast
		}
	}
	
	public var hashValue : Int {
		return description.hashValue
	}
	
	internal var rangeFunctor : ((Brightness) -> Bool) {
		switch self {
		case .Invert(let upper): return ({
			(value : Brightness) -> Bool in
			return value <= upper
		})
		case .Regular(let lower, let upper): return ({
			(value : Brightness) -> Bool in
			return value <= upper && value >= lower
		})
		case .Contrast(let lower): return ({
			(value : Brightness) -> Bool in
			return value >= lower
		})
		}
	}
}

public protocol AmbienceListener : class {
	func ambience (didChangeFrom previousState : AmbienceState?, to currentState : AmbienceState)
}

public class Ambience {
	
	internal weak var listener : AmbienceListener!
	
	internal var previousState : AmbienceState?
	internal var currentState : AmbienceState = .Regular {
        willSet {
            previousState = currentState
        }
        didSet {
            listener.ambience(didChangeFrom: previousState, to: currentState)
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

	
	public init (listener : AmbienceListener) {
		self.listener = listener
		
        NotificationCenter.default.addObserver(self,
            selector: #selector(brightnessDidChange),
			name: NSNotification.Name.UIScreenBrightnessDidChange,
			object: nil)
		
		checkBrightnessValue()
		
		listener.ambience(didChangeFrom: previousState, to: currentState)
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
