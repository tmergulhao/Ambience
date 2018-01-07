//
//  UITraitCollection+Ambience.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 07/01/18.
//

import UIKit

extension UITraitCollection {
    
    struct AmbienceMode : OptionSet, Hashable {
        
        let rawValue : Int
        var hashValue: Int { return rawValue }
        
        static let regular  = AmbienceMode(rawValue: 0)
        static let contrast = AmbienceMode(rawValue: 1 << 0)
        static let invert   = AmbienceMode(rawValue: 1 << 1)
        static let forced   = AmbienceMode(rawValue: 1 << 2)
        
        static let regularForced  : AmbienceMode = [.forced, .regular]
        static let contrastForced : AmbienceMode = [.forced, .contrast]
        static let invertForced   : AmbienceMode = [.forced, .invert]
    }
    
    var ambienceMode : AmbienceMode {
        get {
            if let value = objc_getAssociatedObject(self, &KeyValues.ambienceTrait) as? AmbienceMode {
                return value
            }
            
            self.ambienceMode = AmbienceMode.regular
            
            return self.ambienceMode
        }
        set { objc_setAssociatedObject(self, &KeyValues.ambienceTrait, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    convenience init(ambienceMode ambience : AmbienceMode) {
        
        self.init()
        
        self.ambienceMode = ambience
    }
}
