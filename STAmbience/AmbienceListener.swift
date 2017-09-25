//
//  AmbienceListener.swift
//  STAmbience
//
//  Created by Tiago Mergulhão on 25/09/2017.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

public protocol AmbienceListener : class {
    func ambience (didChangeFrom previousState : AmbienceState?, to currentState : AmbienceState)
}

public extension AmbienceListener {
    func setupAmbience() {
        Ambience.insert(self)
    }
    
    func removeAmbience () {
        Ambience.remove(self)
    }
}
