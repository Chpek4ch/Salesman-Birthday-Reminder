//
//  DispatchManager.swift
//  Salesman Birthday Reminder
//
//  Created by Влад Карпенко on 14/04/2019.
//  Copyright © 2019 karpenko vlad. All rights reserved.
//

import Foundation


open class DispatchManager {
    
    
    
    public func dispatchTrhead(_ global: @escaping ()->(),_ main: @escaping ()->()){
        
        DispatchQueue.global().async {
            global()
            DispatchQueue.main.async {
                main()
            }
        }
    }
    
    
    
}
