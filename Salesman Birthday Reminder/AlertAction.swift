//
//  AlertAction.swift
//  TeamCampaigns
//
//  Created by karpenko vlad on 28.12.2018.
//  Copyright © 2018 karpenko vlad. All rights reserved.
//

import UIKit


class Alert {

  
    class func deleteAlert(message: String,_ vc: UIViewController,closure : @escaping ()->(),cancel : @escaping ()->()) {
        let alertController = UIAlertController.init(title: "Delete Event", message: message, preferredStyle: .alert)
       
        
        alertController.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (action) in
            closure()
        }))
        
        alertController.addAction(UIAlertAction.init(title: "No", style: .cancel, handler: { (action) in
        cancel()
        }))
        
        
        vc.present(alertController, animated: true) {
        }
    }
    
    

    class func internetAlert(_ vc: UIViewController) {
        let alertController = UIAlertController.init(title: "Connection Failed", message: "There may be a problem in your internet connection. Please try again", preferredStyle: .actionSheet)
        
        
        alertController.addAction(UIAlertAction.init(title: "Refresh", style: .cancel, handler: { (action) in
           ConnectionManager.sharedInstance.observeReachability(vc)
        }))
        
        
        vc.present(alertController, animated: true) {
        }
    }
    
    class func registerAlert(message: String,_ vc: UIViewController) {
        let alertController = UIAlertController.init(title: "Register", message: message, preferredStyle: .alert)
        
        
        alertController.addAction(UIAlertAction.init(title: "Ok", style: .cancel, handler: { (action) in
           
        }))
        
       
        
        
        vc.present(alertController, animated: true) {
        }
    }
    
    
    class func signInAlert(message: String,_ vc: UIViewController) {
        let alertController = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert)
        
        
        alertController.addAction(UIAlertAction.init(title: "Ok", style: .cancel, handler: { (action) in
            
        }))
        
        
        
        
        vc.present(alertController, animated: true) {
        }
    }
    
    class func forgotAlert(message: String,_ vc: UIViewController) {
        let alertController = UIAlertController.init(title: "Forgot Password", message: message, preferredStyle: .alert)
        
        
        alertController.addAction(UIAlertAction.init(title: "Ok", style: .cancel, handler: { (action) in
            
        }))
        
        
        
        
        vc.present(alertController, animated: true) {
        }
    }
    
    
    class func logoutAlert(message: String,_ vc: UIViewController,closure : @escaping ()->()) {
        let alertController = UIAlertController.init(title: "Log out", message: message, preferredStyle: .alert)
        
        
        alertController.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (action) in
            closure()
        }))
        
        alertController.addAction(UIAlertAction.init(title: "No", style: .cancel, handler: { (action) in
           
        }))
        
        
        vc.present(alertController, animated: true) {
        }
    }
    
    class func emptyImagelAlert(message: String,_ vc: UIViewController) {
        let alertController = UIAlertController.init(title: "Save Event Error", message: message, preferredStyle: .alert)
        
        
        alertController.addAction(UIAlertAction.init(title: "Continue", style: .cancel, handler: { (action) in
            
        }))
        
        
        vc.present(alertController, animated: true) {
        }
    }
    
    
}
