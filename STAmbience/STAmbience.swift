//
//  STAmbience.swift
//  STAmbience
//
//  Created by Tiago Mergulhão on 21/02/15.
//  Copyright (c) 2015 Tiago Mergulhão. All rights reserved.
//

import UIKit

//	TODO: Dynamic thresholds

public typealias STBrightness = CGFloat

private func inBetween<T : Comparable>(value : T, border : (lower : T, upper : T)) -> Bool {
	return value >= border.lower && value <= border.upper
}

public enum AmbienceState : Printable {
	case Invert, Regular, Contrast
	
	public var description : String {
		switch self {
		case .Invert: return "invert"
		case .Regular: return "regular"
		case .Contrast: return "contrast"
		}
	}
	
	private var range : (STBrightness, STBrightness) {
		switch self {
		case .Invert: return (0.0, 0.05)
		case .Regular: return (0.1, 0.9)
		case .Contrast: return (0.95, 1)
		}
	}
	
	private func inBrightnessRange (value : STBrightness) -> Bool {
		return inBetween(value, self.range)
	}
	
	private static func acceptableStates (forBrightness value : STBrightness) -> Set<AmbienceState> {
		
		var acceptableStates : Set<AmbienceState> = []
		
		if AmbienceState.Regular.inBrightnessRange(value) {
			acceptableStates.insert(.Regular)
		}
		
		if AmbienceState.Invert.inBrightnessRange(value) {
			acceptableStates.insert(.Invert)
		}
		if AmbienceState.Contrast.inBrightnessRange(value) {
			acceptableStates.insert(.Contrast)
		}
		
		return acceptableStates
	}
}

public extension UIViewController {
	final func notifyAmbience () {
		STAmbience.viewControllers.insert(self)
		ambience (didChangeFrom: STAmbience.lastState, to: STAmbience.state)
	}
	
	final func stopAmbience () {
		STAmbience.viewControllers.remove(self)
	}
	
	func ambience (didChangeFrom lastState : AmbienceState?, to currentState : AmbienceState) {}
}

private class STAmbience : NSObject {
	
	private static var viewControllers : Set<UIViewController> = [] {
		willSet {
			if viewControllers.isEmpty {
				checkBrightnessState()
			}
		}
		didSet {
			if viewControllers.isEmpty {
				NSNotificationCenter.defaultCenter().removeObserver(self)
			} else if viewControllers.count == 1 {
				NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("brightnessDidChange:"), name: UIScreenBrightnessDidChangeNotification, object: nil)
			}
		}
	}
	
	private static var lastState : AmbienceState?
	private static var state : AmbienceState = .Regular {
		willSet {
			lastState = state
		}
		didSet {
			for viewController in viewControllers {
				viewController.ambience(didChangeFrom: lastState, to: state)
			}
		}
	}
	
	private class func checkBrightnessState () {
		let currentBrightness = UIScreen.mainScreen().brightness
		let acceptableStates = AmbienceState.acceptableStates(forBrightness: currentBrightness)
		
		if let someState = acceptableStates.first where !acceptableStates.contains(state) {
			state = someState
		}
	}
	
	private class func brightnessDidChange (notification : NSNotification) {
		checkBrightnessState()
	}
	
}
