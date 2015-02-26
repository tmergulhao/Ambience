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
public typealias BrightnessRange = (lower : Brightness, upper : Brightness)

internal typealias AmbienceConstraints = Set<AmbienceConstraint>

public enum AmbienceConstraint : Printable, Hashable, Comparable {
	case Invert(upper : Brightness)
	case Regular(lower : Brightness, upper : Brightness)
	case Contrast(lower : Brightness)
	
	public var description : String {
		switch self {
		case .Invert:	return "invert"
		case .Regular:	return "regular"
		case .Contrast: return "contrast"
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

protocol AmbienceListener {
	func ambience (didChangeFrom previousState : AmbienceConstraint?, to currentState : AmbienceConstraint?)
}

public class Ambience : NSObject {
	
	// return false on error
	internal class func insert (#listener : NSObject) -> Bool {
		if let someListener = listener as? AmbienceListener
			where !listeners.contains(listener) {
			listeners.insert(listener)
			
			someListener.ambience(didChangeFrom: previousState, to: currentState)
			
			return false
		}
		
		return true
	}
	
	internal class func remove (#listener : UIViewController) -> Bool {
		if let someListener = listener as? AmbienceListener
			where listeners.contains(listener) {
			listeners.remove(listener)
			
			return false
		}
		
		return true
	}
	
	public class func resetConstraint () {
		constraints = standartConstraints
	}
	internal class func insert ( #constraint : AmbienceConstraint) {
		self.constraints.insert(constraint)
	}
	internal class func insert ( #constraints : AmbienceConstraints) {
		println(constraints)
		self.constraints.unionInPlace(constraints)
	}
	
	private static let standartConstraints : AmbienceConstraints = [
		.Invert(upper: 0.10),
		.Regular(lower: 0.05, upper: 0.95),
		.Contrast(lower: 0.90)
	]
	
	internal static var constraints : AmbienceConstraints = standartConstraints {
		didSet {
			brightnessDidChange(NSNotification(name: "", object: nil))
		}
	}
	
	private static var listeners : Set<NSObject> = [] {
		willSet {
			if listeners.isEmpty {
				brightnessDidChange(NSNotification(name: "", object: nil))
			}
		}
		didSet {
			if listeners.isEmpty {
				NSNotificationCenter.defaultCenter().removeObserver(self)
			} else if listeners.count == 1 {
				NSNotificationCenter.defaultCenter().addObserver(self,
					selector: Selector("brightnessDidChange:"),
					name: UIScreenBrightnessDidChangeNotification,
					object: nil)
			}
		}
	}
	
	private static var previousState : AmbienceConstraint?
	internal static var currentState : AmbienceConstraint? {
		willSet {
			previousState = currentState
		}
		didSet {
			for listener in listeners {
				(listener as! AmbienceListener).ambience(didChangeFrom: previousState, to: currentState)
			}
		}
	}
	
	internal class func brightnessDidChange (notification : NSNotification) {
		let currentBrightness : Brightness = UIScreen.mainScreen().brightness
		
		let acceptableStates : AmbienceConstraints = Set(filter(constraints){
			let functor = $0.rangeFunctor
			return functor(currentBrightness)
		})
		
		if let someState = currentState where !acceptableStates.contains(someState) {
			currentState = acceptableStates.first
		} else if let newState = acceptableStates.first where currentState == nil {
			currentState = newState
		}
	}
	
}
