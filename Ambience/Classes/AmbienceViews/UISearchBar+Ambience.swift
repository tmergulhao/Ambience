//
//  UISearchBar+Ambience.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 02/01/2018.
//

import UIKit

extension UITabBar {
    
    open override func ambience(_ notification : Notification) {
        
        super.ambience(notification)
        
        guard let currentState = notification.userInfo?["currentState"] as? AmbienceState else { return }
        
        barStyle = currentState == .invert ? .black : .default
    }
}
