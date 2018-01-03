//
//  AmbienceObject.swift
//  Ambience
//
//  Created by Tiago Mergulhão on 03/01/2018.
//

import UIKit

class AmbienceObject : NSObject {
    
    @IBOutlet weak var viewController : UIViewController?
    
    @IBAction func switchAmbience (_ sender : AnyObject) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let switchToInvert = UIAlertAction(title: "Invert", style: .default) {
            _ in
            Ambience.forcedState = .invert
        }
        let switchToContrast = UIAlertAction(title: "Contrast", style: .default) {
            _ in
            Ambience.forcedState = .contrast
        }
        let switchToRegular = UIAlertAction(title: "Regular", style: .default) {
            _ in
            Ambience.forcedState = .regular
        }
        
        let switchToAuto = UIAlertAction(title: "Auto", style: .default) {
            _ in
            Ambience.forcedState = nil
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(switchToInvert)
        actionSheet.addAction(switchToContrast)
        actionSheet.addAction(switchToRegular)
        actionSheet.addAction(switchToAuto)
        actionSheet.addAction(cancel)
        
        viewController?.present(actionSheet, animated: true)
    }
}
