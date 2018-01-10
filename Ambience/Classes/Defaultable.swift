//
//  Defaultable.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 02/11/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import Foundation

public protocol Defaultable {}

extension Int : Defaultable {}
extension Double : Defaultable {}
extension Bool : Defaultable {}
extension String : Defaultable {}

public struct Default<Element : Defaultable> {
    
    var key : String
    var value : Element? {
        didSet {
            UserDefaults.standard.set(value, forKey: key)
        }
    }
    
    init (key : String) {
        self.key = key
        self.value = UserDefaults.standard.value(forKey: key) as? Element
    }
}

extension Default : CustomStringConvertible {
    public var description : String {
        return "Default<\(String(describing: Element.self))>(\"\(key)\", \(value != nil ? String(describing: value!) : "nil"))"
    }
}

infix operator « : AssignmentPrecedence

public func «<T>(left : inout Default<T>, right : T?) {
    left.value = right
}

public func «<T>(left : inout T?, right : Default<T>) {
    left = right.value
}
