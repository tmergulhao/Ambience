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

extension Set {
	func filter (functor : (T) -> Bool) -> Set<T> {
		var filteredSet : Set<T> = []
		for item in self {
			if functor(item) {
				filteredSet.insert(item)
			}
		}
		return filteredSet
	}
	func map<U>(functor : T -> U) -> Set<U> {
		var mappedSet : Set<U> = []
		for item in self {
			mappedSet.insert(functor(item))
		}
		return mappedSet
	}
}

public typealias Brightness = CGFloat
internal typealias BrightnessRange = (lower : Brightness, upper : Brightness)

internal typealias AmbienceConstraints = Set<AmbienceConstraint>
internal typealias AmbienceStates = Set<AmbienceState>

public enum AmbienceState : String {
	case Invert = "invert"
	case Regular = "regular"
	case Contrast = "contrast"
}

public enum AmbienceConstraint : Printable, Hashable, Comparable {
	case Invert(upper : Brightness)
	case Regular(lower : Brightness, upper : Brightness)
	case Contrast(lower : Brightness)
	
	public var description : String {
		return self.state.rawValue
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
	func ambience (didChangeFrom previousState : AmbienceState?, to currentState : AmbienceState?)
}

public class Ambience : NSObject {
	
	private var previousState : AmbienceState?
	internal var currentState : AmbienceState? {
		willSet {
			previousState = currentState
		}
		didSet {
			listener?.ambience(didChangeFrom: previousState, to: currentState)
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
	
	internal func processConstraints (forBrightness value : Brightness) {
		let acceptableStates : AmbienceStates = constraints.filter({
			$0.rangeFunctor(value)
		}).map({
			$0.state
		})
		
		if let someState = currentState where !acceptableStates.contains(someState) {
			currentState = acceptableStates.first
		} else if let newState = acceptableStates.first where currentState == nil {
			currentState = newState
		}
	}
	internal func checkBrightnessValue () {
		processConstraints(forBrightness : UIScreen.mainScreen().brightness)
	}
	internal func brightnessDidChange (notification : NSNotification) {
		checkBrightnessValue()
	}
	
	internal func insert ( #constraint : AmbienceConstraint ) {
		self.constraints.insert(constraint)
	}
	internal func insert ( #constraints : AmbienceConstraints ) {
		println(constraints)
		self.constraints.unionInPlace(constraints)
	}
	
	private weak var listener : AmbienceListener?
	
	public init (listener : AmbienceListener) {
		self.listener = listener
		
		super.init()
		
		NSNotificationCenter.defaultCenter().addObserver(self,
			selector: Selector("brightnessDidChange:"),
			name: UIScreenBrightnessDidChangeNotification,
			object: nil)
		
		checkBrightnessValue()
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
}
