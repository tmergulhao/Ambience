//
//  KeyValues.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 15/12/17.
//

import Foundation

internal struct Properties {

    var backgroundColor = "backgroundColor"
    var textColor = "textColor"
}

internal struct KeyValues {
    
    static var notificationManager = "notificationManager"
    static var ambience = "ambience"
    static var ambienceTrait = "ambienceTrait"
    
    static var regular =    Properties()
    static var contrast =   Properties()
    static var invert =     Properties()
}
