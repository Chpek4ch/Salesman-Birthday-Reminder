//
//  UserDataManager.swift
//  Salesman Birthday Reminder
//
//  Created by Влад Карпенко on 04/04/2019.
//  Copyright © 2019 karpenko vlad. All rights reserved.
//

import Foundation

private let userManager = UserDataManager()

class UserDataManager {
    var currentData: UserData?
    
    class var shared: UserDataManager {
        return userManager
    }
}
