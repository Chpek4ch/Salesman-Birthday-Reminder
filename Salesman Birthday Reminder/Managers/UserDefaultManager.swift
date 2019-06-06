//
//  UserDefaultManager.swift
//  Salesman Birthday Reminder
//
//  Created by Влад Карпенко on 09/04/2019.
//  Copyright © 2019 karpenko vlad. All rights reserved.
//

import Foundation
import UIKit

class UserDefaultManager {
    
    
    let userDef = UserDefaults.standard
    
    public func saveUser(_ email: String,_ pass: String) {
        userDef.set(email, forKey: "email")
        userDef.set(pass, forKey: "pass")
        userDef.synchronize()
    }
    
    public func getUser(_ closure:@escaping (String,String,Bool)->())  {
        
        
        if getTextByKey("email") != "" && getTextByKey("pass") != "" {
                closure(getTextByKey("email"),getTextByKey("pass"),true)
            
        }
      
       
    }
    
    public func getTextByKey(_ stringKey: String) -> String {
        var string = ""
        if let curentString = userDef.value(forKey: stringKey) as? String  {
            string = curentString
        }
        
        userDef.synchronize()
        return string
        
    }
    
    public func clearUser(){
        userDef.removeObject(forKey: "email")
        userDef.removeObject(forKey: "pass")
        userDef.synchronize()
    }
    
}
