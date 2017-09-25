//
//  AmbienceConstraint.swift
//  STAmbience
//
//  Created by Tiago Mergulhão on 25/09/2017.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import Foundation

public func ==(lhs: AmbienceConstraint, rhs: AmbienceConstraint) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
public func <(lhs: AmbienceConstraint, rhs: AmbienceConstraint) -> Bool {
    return lhs.hashValue < rhs.hashValue
}

public typealias AmbienceConstraints = Set<AmbienceConstraint>

public enum AmbienceConstraint : Hashable, Comparable, CustomStringConvertible {
    case Invert(upper : Brightness)
    case Regular(lower : Brightness, upper : Brightness)
    case Contrast(lower : Brightness)
    
    public var description : String {
        switch self {
        case .Invert(let upper): return "Invert<\(upper)>"
        case .Regular(let lower, let upper): return "Invert<\(lower), \(upper)>"
        case .Contrast(let lower): return "Contrast<\(lower)>"
        }
    }
    
    public var state : AmbienceState {
        switch self {
        case .Invert:    return AmbienceState.Invert
        case .Regular:    return AmbienceState.Regular
        case .Contrast: return AmbienceState.Contrast
        }
    }
    
    public var hashValue : Int {
        return description.hashValue
    }
    
    internal var rangeFunctor : ((Brightness) -> Bool) {
        switch self {
        case .Invert(let upper): return ({
            (value : Brightness) -> Bool in
            return value <= upper
        })
        case .Regular(let lower, let upper): return ({
            (value : Brightness) -> Bool in
            return value <= upper && value >= lower
        })
        case .Contrast(let lower): return ({
            (value : Brightness) -> Bool in
            return value >= lower
        })
        }
    }
}
