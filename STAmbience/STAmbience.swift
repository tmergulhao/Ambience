//
//  STAmbience.swift
//  STAmbience
//
//  Created by Tiago Mergulhão on 21/02/15.
//  Copyright (c) 2015 Tiago Mergulhão. All rights reserved.
//

import UIKit

public typealias STBrightness = CGFloat

private func inBetween<T : Comparable>(value : T, border : (lower : T, upper : T)) -> Bool {
	return value >= border.lower && value <= border.upper
}

public enum AmbienceState : Int, Printable {
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
	
	internal static func acceptableStates (forBrightness value : STBrightness) -> Array<AmbienceState> {
		
		var acceptableStates : Array<AmbienceState> = []
		
		if AmbienceState.Regular.inBrightnessRange(value) {
			acceptableStates.append(.Regular)
		}
		
		if AmbienceState.Invert.inBrightnessRange(value) {
			acceptableStates.append(.Invert)
		}
		if AmbienceState.Contrast.inBrightnessRange(value) {
			acceptableStates.append(.Contrast)
		}
		
		return acceptableStates
	}
}

public protocol STAmbienceViewController : NSObjectProtocol { // UIViewController
	
	func ambience (didChangeFrom lastState : AmbienceState?, to currentState : AmbienceState)
}

public extension UIViewController {
	func notifyAmbience () -> Bool {
		if let someSelf = self as? STAmbienceViewController {
			STAmbience.viewControllers.append(someSelf)
			
			someSelf.ambience(didChangeFrom: STAmbience.lastState, to: STAmbience.state)
			
			return true
		} else {
			return false
		}
	}
	
	func stopAmbience () {
		STAmbience.viewControllers = STAmbience.viewControllers.filter({ ($0 as! UIViewController) != self })
	}
}

internal class STAmbience : NSObject {
	
	// TRY APPLYING SETS FOR DUPLICATE SAFETY
	
	private static var viewControllers : Array<STAmbienceViewController> = [] {
		willSet {
		if viewControllers.isEmpty {
		checkBrightnessState()
		}
		}
		didSet {
			if viewControllers.isEmpty {
				NSNotificationCenter.defaultCenter().removeObserver(self)
			} else {
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
		
		if let someState = acceptableStates.first where acceptableStates.filter({ $0 == self.state }).isEmpty {
			state = someState
		}
	}
	
	internal class func brightnessDidChange (notification : NSNotification) {
		checkBrightnessState()
	}
	
}
