//
//  STAmbienceTests.swift
//  STAmbienceTests
//
//  Created by Tiago Mergulhão on 21/02/15.
//  Copyright (c) 2015 Tiago Mergulhão. All rights reserved.
//

import XCTest

import STAmbience

private class Ambience_Test : Ambience {
	private var dummyBrightness : Brightness = 0.5 {
		didSet {
			processConstraints(forBrightness: dummyBrightness)
		}
	}
}

class SomeViewController : UIViewController, AmbienceListener {
	
	var currentState : AmbienceState?
	
	func ambience (didChangeFrom previousState : AmbienceState?, to currentState : AmbienceState?) {
		self.currentState = currentState
	}
}

class STAmbienceTests: XCTestCase {
	
	var someViewController : SomeViewController!
	private var someAmbience : Ambience_Test!
    
    override func setUp() {
        super.setUp()
		
		someViewController = SomeViewController()
		someAmbience = Ambience_Test(listener: someViewController)
    }
    
    override func tearDown() {
        super.tearDown()
    }
	
	func testRangeSustaining () {
		
		someAmbience.dummyBrightness = 0.5
		
		someAmbience.dummyBrightness = 0.05
		
		XCTAssert(someViewController.currentState?.rawValue == "regular", "Sustained inclusive transition")
		
		someAmbience.dummyBrightness = 0.01
		
		XCTAssert(someViewController.currentState?.rawValue == "invert", "Transition to lower range")
		
		someAmbience.dummyBrightness = 0.05
		
		XCTAssert(someViewController.currentState?.rawValue == "invert", "Sustained inclusive transition")
	}
	
	func testRangeVoiding () {
		
		someAmbience.dummyBrightness = 0.5
		
		someAmbience.insert(constraint: AmbienceConstraint.Regular(lower: 0.4, upper: 1.0))
		
		someAmbience.dummyBrightness = 0.05
		
		XCTAssert(someViewController.currentState?.rawValue == "invert", "Lower range")
		
		someAmbience.dummyBrightness = 0.5
		
		XCTAssert(someViewController.currentState?.rawValue == "regular", "Middle range")
		
		someAmbience.dummyBrightness = 0.3
		
		XCTAssert(someViewController.currentState == nil, "Void range")
	}
	
	func testInsertConstraintSet () {
		
		someAmbience.dummyBrightness = 0.5
		
		someAmbience.insert(constraints: [
			AmbienceConstraint.Invert(upper: 0.2),
			AmbienceConstraint.Contrast(lower: 0.99)
		])
		
		someAmbience.dummyBrightness = 0.0
		
		XCTAssert(someViewController.currentState?.rawValue == "invert", "Lower range")
		
		someAmbience.dummyBrightness = 0.2
		
		XCTAssert(someViewController.currentState?.rawValue == "invert", "Lower range")
		
		someAmbience.dummyBrightness = 0.97
		
		XCTAssert(someViewController.currentState == nil, "Void range")
	}
}
