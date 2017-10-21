//
//  AmbienceStates.swift
//  STAmbience
//
//  Created by Tiago Mergulhão on 25/09/2017.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import Foundation

internal typealias AmbienceStates = Set<AmbienceState>

public enum AmbienceState : String {
    case Invert = "invert"
    case Regular = "regular"
    case Contrast = "contrast"
}
