//
//  STAmbienceTests.swift
//  STAmbienceTests
//
//  Created by Tiago Mergulhão on 21/02/15.
//  Copyright (c) 2015 Tiago Mergulhão. All rights reserved.
//

import XCTest

import STAmbience

class SomeViewController : AmbienceViewController {
	
	var previousState : AmbienceConstraint?
	var currentState : AmbienceConstraint?
	
	override func ambience (didChangeFrom previousState : AmbienceConstraint?, to currentState : AmbienceConstraint?) {
		self.previousState = previousState
		self.currentState = currentState
	}
}

class STAmbienceTests: XCTestCase {
	
	let someViewController = SomeViewController()
    
    override func setUp() {
        super.setUp()
		
		STAmbience.insert(someViewController)
		
		STAmbience.dummyMode = true
    }
    
    override func tearDown() {
		STAmbience.remove(someViewController)
		
        super.tearDown()
    }
    
    func testAddingAndRemovingObject () {
		XCTAssert(STAmbience.insert(someViewController), "No duplicate add on STAmbience")
		
		XCTAssert(!STAmbience.remove(someViewController), "Removed of STAmbience")
		XCTAssert(STAmbience.remove(someViewController), "No duplicate remove on STAmbience")
		
		XCTAssert(!STAmbience.insert(someViewController), "Added to STAmbience")
	}
	
	func testRangeSustaining () {
		
		STAmbience.resetConstraint()
		STAmbience.dummyBrightness = 0.5
		
		STAmbience.dummyBrightness = 0.05
		
		XCTAssert(someViewController.currentState?.simpleDescription == "regular", "Sustained inclusive transition")
		
		STAmbience.dummyBrightness = 0.01
		
		XCTAssert(someViewController.currentState?.simpleDescription == "invert", "Transition to lower range")
		
		STAmbience.dummyBrightness = 0.05
		
		XCTAssert(someViewController.currentState?.simpleDescription == "invert", "Sustained inclusive transition")
	}
	
	func testRangeVoiding () {
		
		STAmbience.resetConstraint()
		STAmbience.dummyBrightness = 0.5
		
		STAmbience.insert(AmbienceConstraint.Regular(lower: 0.4, upper: 1.0))
		
		STAmbience.dummyBrightness = 0.05
		
		XCTAssert(someViewController.currentState?.simpleDescription == "invert", "Lower range")
		
		STAmbience.dummyBrightness = 0.5
		
		XCTAssert(someViewController.currentState?.simpleDescription == "regular", "Middle range")
		
		STAmbience.dummyBrightness = 0.3
		
		XCTAssert(someViewController.currentState == nil, "Void range")
	}
	
	func testInsertConstraintSet () {
		
		STAmbience.dummyBrightness = 0.5
		STAmbience.resetConstraint()
		
		STAmbience.insert([
			AmbienceConstraint.Invert(upper: 0.2),
			AmbienceConstraint.Contrast(lower: 0.99)
		])
		
		STAmbience.dummyBrightness = 0.0
		
		XCTAssert(someViewController.currentState?.simpleDescription == "invert", "Lower range")
		
		STAmbience.dummyBrightness = 0.2
		
		XCTAssert(someViewController.currentState?.simpleDescription == "invert", "Lower range")
		
		STAmbience.dummyBrightness = 0.97
		
		XCTAssert(someViewController.currentState == nil, "Void range")
	}
}
