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

class SomeViewController : UIViewController, AmbienceListener {
	
	var previousConstraint : AmbienceConstraint?
	var currentConstraint : AmbienceConstraint?
	
	func ambience (didChangeFrom previousConstraint : AmbienceConstraint?, to currentConstraint : AmbienceConstraint?) {
		self.previousConstraint = previousConstraint
		self.currentConstraint = currentConstraint
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
		
		XCTAssert(someViewController.currentConstraint?.description == "regular", "Sustained inclusive transition")
		
		Ambience_Test.dummyBrightness = 0.01
		
		XCTAssert(someViewController.currentConstraint?.description == "invert", "Transition to lower range")
		
		Ambience_Test.dummyBrightness = 0.05
		
		XCTAssert(someViewController.currentConstraint?.description == "invert", "Sustained inclusive transition")
	}
	
	func testRangeVoiding () {
		
		Ambience_Test.resetConstraint()
		Ambience_Test.dummyBrightness = 0.5
		
		Ambience_Test.insert(constraint: AmbienceConstraint.Regular(lower: 0.4, upper: 1.0))
		
		Ambience_Test.dummyBrightness = 0.05
		
		XCTAssert(someViewController.currentConstraint?.description == "invert", "Lower range")
		
		Ambience_Test.dummyBrightness = 0.5
		
		XCTAssert(someViewController.currentConstraint?.description == "regular", "Middle range")
		
		Ambience_Test.dummyBrightness = 0.3
		
		XCTAssert(someViewController.currentConstraint == nil, "Void range")
	}
	
	func testInsertConstraintSet () {
		
		Ambience_Test.dummyBrightness = 0.5
		Ambience_Test.resetConstraint()
		
		Ambience_Test.insert(constraints: [
			AmbienceConstraint.Invert(upper: 0.2),
			AmbienceConstraint.Contrast(lower: 0.99)
		])
		
		Ambience_Test.dummyBrightness = 0.0
		
		XCTAssert(someViewController.currentConstraint?.description == "invert", "Lower range")
		
		Ambience_Test.dummyBrightness = 0.2
		
		XCTAssert(someViewController.currentConstraint?.description == "invert", "Lower range")
		
		Ambience_Test.dummyBrightness = 0.97
		
		XCTAssert(someViewController.currentConstraint == nil, "Void range")
	}
}
