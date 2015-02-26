//
//  STAmbienceTests.swift
//  STAmbienceTests
//
//  Created by Tiago Mergulhão on 21/02/15.
//  Copyright (c) 2015 Tiago Mergulhão. All rights reserved.
//

import XCTest

import STAmbience

public class Ambience_Test : Ambience {
	public static var dummyBrightness : Brightness = 0.5 {
		didSet {
			brightnessDidChange(NSNotification(name: "", object: nil))
		}
	}
	
	override internal class func brightnessDidChange (notification : NSNotification) {
		let currentBrightness : Brightness = dummyBrightness
		
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

class SomeViewController : UIViewController, AmbienceListener {
	
	var previousState : AmbienceConstraint?
	var currentState : AmbienceConstraint?
	
	func ambience (didChangeFrom previousState : AmbienceConstraint?, to currentState : AmbienceConstraint?) {
		self.previousState = previousState
		self.currentState = currentState
	}
}

class STAmbienceTests: XCTestCase {
	
	let someViewController = SomeViewController()
    
    override func setUp() {
        super.setUp()
		
		Ambience_Test.insert(listener: someViewController)
    }
    
    override func tearDown() {
		Ambience_Test.remove(listener: someViewController)
		
        super.tearDown()
    }
    
    func testAddingAndRemovingObject () {
		XCTAssert(Ambience_Test.insert(listener: someViewController), "No duplicate add on STAmbience")
		
		XCTAssert(!Ambience_Test.remove(listener: someViewController), "Removed of STAmbience")
		XCTAssert(Ambience_Test.remove(listener: someViewController), "No duplicate remove on STAmbience")
		
		XCTAssert(!Ambience_Test.insert(listener: someViewController), "Added to STAmbience")
	}
	
	func testRangeSustaining () {
		
		Ambience_Test.resetConstraint()
		Ambience_Test.dummyBrightness = 0.5
		
		Ambience_Test.dummyBrightness = 0.05
		
		XCTAssert(someViewController.currentState?.description == "regular", "Sustained inclusive transition")
		
		Ambience_Test.dummyBrightness = 0.01
		
		XCTAssert(someViewController.currentState?.description == "invert", "Transition to lower range")
		
		Ambience_Test.dummyBrightness = 0.05
		
		XCTAssert(someViewController.currentState?.description == "invert", "Sustained inclusive transition")
	}
	
	func testRangeVoiding () {
		
		Ambience_Test.resetConstraint()
		Ambience_Test.dummyBrightness = 0.5
		
		Ambience_Test.insert(constraint: AmbienceConstraint.Regular(lower: 0.4, upper: 1.0))
		
		Ambience_Test.dummyBrightness = 0.05
		
		XCTAssert(someViewController.currentState?.description == "invert", "Lower range")
		
		Ambience_Test.dummyBrightness = 0.5
		
		XCTAssert(someViewController.currentState?.description == "regular", "Middle range")
		
		Ambience_Test.dummyBrightness = 0.3
		
		XCTAssert(someViewController.currentState == nil, "Void range")
	}
	
	func testInsertConstraintSet () {
		
		Ambience_Test.dummyBrightness = 0.5
		Ambience_Test.resetConstraint()
		
		Ambience_Test.insert(constraints: [
			AmbienceConstraint.Invert(upper: 0.2),
			AmbienceConstraint.Contrast(lower: 0.99)
		])
		
		Ambience_Test.dummyBrightness = 0.0
		
		XCTAssert(someViewController.currentState?.description == "invert", "Lower range")
		
		Ambience_Test.dummyBrightness = 0.2
		
		XCTAssert(someViewController.currentState?.description == "invert", "Lower range")
		
		Ambience_Test.dummyBrightness = 0.97
		
		XCTAssert(someViewController.currentState == nil, "Void range")
	}
}
