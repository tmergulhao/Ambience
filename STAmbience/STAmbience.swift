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

public enum AmbienceConstraint : Printable, Hashable, Comparable {
	case Invert(upper : Brightness)
	case Regular(lower : Brightness, upper : Brightness)
	case Contrast(lower : Brightness)
	
	public var simpleDescription : String {
		switch self {
		case .Invert(let upper): return "invert"
		case .Regular(let lower, let upper): return "regular"
		case .Contrast(let lower): return "contrast"
		}
	}
	
	public var description : String {
		switch self {
		case .Invert(let upper): return "invert \(0.0, upper)"
		case .Regular(let lower, let upper): return "regular \(lower, upper)"
		case .Contrast(let lower): return "contrast \(lower, 1.0)"
		}
	}
	
	public var hashValue : Int {
		switch self {
		case .Invert: return simpleDescription.hashValue
		case .Regular: return simpleDescription.hashValue
		case .Contrast: return simpleDescription.hashValue
		}
	}
	
	private var range : (lower : Brightness, upper : Brightness) {
		switch self {
		case .Invert(let upper): return (0.0, upper)
		case .Regular(let lower, let upper): return (lower, upper)
		case .Contrast(let lower): return (lower, 1)
		}
	}
	
	private func inBrightnessRange (value : Brightness) -> Bool {
		return value >= range.lower && value <= range.upper
	}
}

public class AmbienceViewController : UIViewController {
	func ambience (didChangeFrom previousState : AmbienceConstraint?, to currentState : AmbienceConstraint?) {}
}

public class STAmbience : NSObject {
	
	// return false on error
	internal class func insert (viewController : AmbienceViewController) -> Bool {
		if !viewControllers.contains(viewController) {
			viewControllers.insert(viewController)
			
			viewController.ambience(didChangeFrom: previousState, to: currentState)
			
			return false
		}
		
		return true
	}
	
	internal class func remove (viewController : AmbienceViewController) -> Bool {
		if viewControllers.contains(viewController) {
			viewControllers.remove(viewController)
			
			return false
		}
		
		return true
	}
	
	public class func resetConstraint () {
		constraints = standartConstraints
	}
	internal class func insert (newConstraint : AmbienceConstraint) {
		constraints.insert(newConstraint)
	}
	internal class func insert (newConstraints : Set<AmbienceConstraint>) {
		println(newConstraints)
		println(constraints)
		constraints.unionInPlace(newConstraints)
	}
	
	private static let standartConstraints : Set<AmbienceConstraint> = [
		.Invert(upper: 0.10),
		.Regular(lower: 0.05, upper: 0.95),
		.Contrast(lower: 0.90)
	]
	
	private static var constraints  = standartConstraints {
		didSet {
			brightnessDidChange(NSNotification(name: "", object: nil))
		}
	}
	
	private static var viewControllers : Set<AmbienceViewController> = [] {
		willSet {
			if viewControllers.isEmpty {
				brightnessDidChange(NSNotification(name: "", object: nil))
			}
		}
		didSet {
			if viewControllers.isEmpty {
				NSNotificationCenter.defaultCenter().removeObserver(self)
			} else if viewControllers.count == 1 {
				NSNotificationCenter.defaultCenter().addObserver(self,
					selector: Selector("brightnessDidChange:"),
					name: UIScreenBrightnessDidChangeNotification,
					object: nil)
			}
		}
	}
	
	private static var previousState : AmbienceConstraint?
	private static var currentState : AmbienceConstraint? {
		willSet {
			previousState = currentState
		}
		didSet {
			for viewController in viewControllers {
				viewController.ambience(didChangeFrom: previousState, to: currentState)
			}
		}
	}
	
	public static var dummyMode : Bool = false
	public static var dummyBrightness : Brightness = 0.5 {
		didSet {
			brightnessDidChange(NSNotification(name: "", object: nil))
		}
	}
	
	private class func brightnessDidChange (notification : NSNotification) {
		let currentBrightness : Brightness = dummyMode ? dummyBrightness : UIScreen.mainScreen().brightness
		
		let acceptableStates : Set<AmbienceConstraint> = Set(filter(constraints){
			$0.inBrightnessRange(currentBrightness)
		})
		
		if let someState = currentState where !acceptableStates.contains(someState) {
			currentState = acceptableStates.first
		} else if let newState = acceptableStates.first where currentState == nil {
			currentState = newState
		}
	}
	
}
