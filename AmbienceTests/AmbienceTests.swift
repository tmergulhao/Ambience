//
//  STAmbienceTests.swift
//  STAmbienceTests
//
//  Created by Tiago Mergulhão on 21/02/15.
//  Copyright (c) 2015 Tiago Mergulhão. All rights reserved.
//

import XCTest

import Ambience

class Ambience_Test : Ambience {
	
    static var brightness : Brightness = 0.5 {
		didSet {
			shared.processConstraints(forBrightness: brightness)
		}
	}
}

class SomeView : AmbienceView {

	var currentState : AmbienceState?
    
    init() {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc override func ambience(_ notification : Notification) {
        currentState = notification.userInfo?["currentState"] as? AmbienceState
    }
}

class AmbienceTests: XCTestCase {
	
	var view : SomeView!
	private var someAmbience : Ambience_Test!
    
    override func setUp() {
        super.setUp()
		
        view = SomeView()
        
        Ambience_Test.add(listener: view)
    }
    
    override func tearDown() {
        super.tearDown()
        
        Ambience_Test.remove(listener: view)
    }
	
	func testRangeSustaining () {
		
		Ambience_Test.brightness = 0.5
		
		Ambience_Test.brightness = 0.05
		
		XCTAssert(view.currentState?.rawValue == "regular", "Sustained inclusive transition")
		
		Ambience_Test.brightness = 0.01
		
		XCTAssert(view.currentState?.rawValue == "invert", "Transition to lower range")
		
		Ambience_Test.brightness = 0.05
		
		XCTAssert(view.currentState?.rawValue == "invert", "Sustained inclusive transition")
	}
	
	func testRangeVoiding () {
		
        Ambience_Test.brightness = 0.5
        
        Ambience_Test.shared.insert(AmbienceConstraint.Regular(lower: 0.4, upper: 1.0))
        
        Ambience_Test.brightness = 0.05
        
        XCTAssert(view.currentState?.rawValue == "invert", "Lower range")
        
        Ambience_Test.brightness = 0.5
        
        XCTAssert(view.currentState?.rawValue == "regular", "Middle range")
        
        Ambience_Test.brightness = 0.3
        
        XCTAssert(view.currentState != nil, "Void range")
	}
	
	func testInsertConstraintSet () {
		
        Ambience_Test.brightness = 0.5

        Ambience_Test.shared.insert([
            AmbienceConstraint.Invert(upper: 0.2),
            AmbienceConstraint.Contrast(lower: 0.99)
        ])

        Ambience_Test.brightness = 0.0

        XCTAssert(view.currentState?.rawValue == "invert", "Lower range")

        Ambience_Test.brightness = 0.2

        XCTAssert(view.currentState?.rawValue == "invert", "Lower range")

        Ambience_Test.brightness = 0.97

        XCTAssert(view.currentState != nil, "Void range")
	}
}
