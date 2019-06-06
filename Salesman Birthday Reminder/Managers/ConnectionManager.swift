//
//  ConnectionManager.swift
//  TeamCampaigns
//
//  Created by karpenko vlad on 03.01.2019.
//  Copyright © 2019 karpenko vlad. All rights reserved.
//

import UIKit


class ConnectionManager {
    
    static let sharedInstance = ConnectionManager()
    private var reachability: Reachability!
    var network = ""
    var view: UIViewController!
  
    
    func observeReachability(_ view: UIViewController)  {
        self.view = view
        self.reachability = Reachability()
        NotificationCenter.default.addObserver(self, selector:#selector(self.reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
        do {
            try self.reachability.startNotifier()
           
        }
        catch(let error) {
            print("Error occured while starting reachability notifications : \(error.localizedDescription)")
        }
        
        
    }
    
    @objc func reachabilityChanged(note: Notification)  -> Bool {
        let reachability = note.object as! Reachability

        switch reachability.connection {
        case .cellular:
            network = "1"
          changeViewVisible()
            print("Network available via Cellular Data.")
            break
        case .wifi:
            network = "2"
            changeViewVisible()
            print("Network available via WiFi.")
            break
        case .none:
            network = "3"
           changeViewVisible()
            print("Network is not available.")
            break
        }
        return true
    }
    
    
    func changeViewVisible()  {
        if network == "1" || network == "2" {
        } else if network == "3" {
           Alert.internetAlert(view)
        }
        
    }
}
