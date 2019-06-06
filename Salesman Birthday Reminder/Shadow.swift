//
//  Shadow.swift
//  Salesman Birthday Reminder
//
//  Created by karpenko vlad on 3/21/19.
//  Copyright © 2019 karpenko vlad. All rights reserved.
//

import UIKit


    
    extension UIView {
        
        func dropShadow(_ opacity: Float) {
            self.layer.shadowColor = UIColor.gray.cgColor
            self.layer.shadowOpacity = opacity
            self.layer.shadowOffset = CGSize.zero
            self.layer.shadowRadius = 8
            
        }
    }


