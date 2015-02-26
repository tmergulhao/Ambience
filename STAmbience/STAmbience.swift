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

public protocol AmbienceListener {
	func ambience (didChangeFrom previousConstraint : AmbienceConstraint?, to currentConstraint : AmbienceConstraint?)
}

public class Ambience : NSObject {
	
	// return false on error
	public class func insert (#listener : NSObject) -> Bool {
		if let someListener = listener as? AmbienceListener
			where !listeners.contains(listener) {
			listeners.insert(listener)
			
			someListener.ambience(didChangeFrom: previousConstraint, to: currentConstraint)
			
			return false
		}
		
		return true
	}
	
	public class func remove (#listener : NSObject) -> Bool {
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
	
	private static var previousConstraint : AmbienceConstraint?
	internal static var currentConstraint : AmbienceConstraint? {
		willSet {
			previousConstraint = currentConstraint
		}
		didSet {
			for listener in listeners {
				(listener as! AmbienceListener).ambience(didChangeFrom: previousConstraint, to: currentConstraint)
			}
		}
	}
	
	internal class func brightnessDidChange (notification : NSNotification) {
		let currentBrightness : Brightness = UIScreen.mainScreen().brightness
		
		let acceptableConstraints : AmbienceConstraints = Set(filter(constraints){
			let functor = $0.rangeFunctor
			return functor(currentBrightness)
		})
		
		if let someConstraint = currentConstraint where !acceptableConstraints.contains(someConstraint) {
			currentConstraint = acceptableConstraints.first
		} else if let newConstraint = acceptableConstraints.first where currentConstraint == nil {
			currentConstraint = newConstraint
		}
	}
	
}
