//
//  Swizzling.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 15/12/17.
//

import Foundation

internal extension NSObject {
    
    internal class func swizzling (forClass : AnyClass, originalSelector : Selector, swizzledSelector : Selector) {
        
        guard let originalMethod = class_getInstanceMethod(forClass, originalSelector) else { return }
        guard let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector) else { return }

        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
