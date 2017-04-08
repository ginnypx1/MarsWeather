//
//  Alerts.swift
//  MarsWeather
//
//  Created by Ginny Pennekamp on 4/4/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Alerts

class Alerts {
    
    // display Internet Out alert
    static func displayInternetConnectionAlert(from viewController: UIViewController) {
        
        let alertController = UIAlertController(title: "No Internet Connection", message: "Please Make Sure Your Device is Connected to the Internet.", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { (action: UIAlertAction) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        // Change font of the title and message
        let messageFont:[String : AnyObject] = [ NSFontAttributeName : UIFont(name: "HelveticaNeue", size: 14)! ]
        let attributedMessage = NSMutableAttributedString(string: "Please Make Sure Your Device is Connected to the Internet.", attributes: messageFont)
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
        // add actions to alert controller
        alertController.addAction(dismissAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    // display download fail
    static func displayStandardAlert(from viewController: UIViewController) {
        
        let alertController = UIAlertController(title: nil, message: "There Was an Error Retrieving the Weather Data.", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { (action: UIAlertAction) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        // Change font of the title and message
        let messageFont:[String : AnyObject] = [ NSFontAttributeName : UIFont(name: "HelveticaNeue", size: 14)! ]
        let attributedMessage = NSMutableAttributedString(string: "There Was an Error Retrieving the Weather Data.", attributes: messageFont)
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
        // add actions to alert controller
        alertController.addAction(dismissAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    // display geocode fail
    static func displayLocationAlert(from viewController: UIViewController) {
        
        let alertController = UIAlertController(title: nil, message: "There Was an Error Retrieving the User's Location.", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { (action: UIAlertAction) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        // Change font of the title and message
        let messageFont:[String : AnyObject] = [ NSFontAttributeName : UIFont(name: "HelveticaNeue", size: 14)! ]
        let attributedMessage = NSMutableAttributedString(string: "There Was an Error Retrieving the User's Location", attributes: messageFont)
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
        // add actions to alert controller
        alertController.addAction(dismissAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}
