//
//  UINavigationBar+Ambience.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 03/01/2018.
//

import UIKit

extension UINavigationBar {
    
    public override func ambience(_ notification : Notification) {
        
        super.ambience(notification)
        
        guard let currentState = notification.userInfo?["currentState"] as? AmbienceState else { return }
        
        barStyle = currentState == .invert ? .black : .default
    }
}
