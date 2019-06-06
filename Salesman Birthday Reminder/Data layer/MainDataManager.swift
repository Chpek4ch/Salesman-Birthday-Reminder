//
//  MainDataManager.swift
//  Salesman Birthday Reminder
//
//  Created by karpenko vlad on 3/21/19.
//  Copyright © 2019 karpenko vlad. All rights reserved.
//

import Foundation

private let mainManager = MainDataManager()

class MainDataManager {
    var currentData: [MainData]?
    
    class var shared: MainDataManager {
        return mainManager
    }
}
