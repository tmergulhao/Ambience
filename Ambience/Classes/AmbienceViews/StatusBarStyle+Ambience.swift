//
//  UIViewController+Ambience.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 06/01/2018.
//

import UIKit

extension UITableViewController {
    
    @objc override open var preferredStatusBarStyle : UIStatusBarStyle {
        
        if !ambience { return .default }
        
        switch Ambience.currentState {
        case .invert:
            return .lightContent
        case .contrast, .regular:
            return .default
        }
    }
}

extension UICollectionViewController {
    
    @objc override open var preferredStatusBarStyle : UIStatusBarStyle {
        
        if !ambience { return .default }
        
        switch Ambience.currentState {
        case .invert:
            return .lightContent
        case .contrast, .regular:
            return .default
        }
    }
}
