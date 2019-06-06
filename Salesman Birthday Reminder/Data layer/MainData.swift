//
//  MainData.swift
//  Salesman Birthday Reminder
//
//  Created by karpenko vlad on 3/21/19.
//  Copyright © 2019 karpenko vlad. All rights reserved.
//

import UIKit


struct MainData {
  
    var name: String
    var city: String
    var age: String
    var image: UIImage
    var slider: Double
    var profession: String
    var company: String
    var dateOfBirth: String
    var email: String
    var gender: String
    var phone: String
    var placeAndDate: String
    var address: String
    var stat: String
    var id: String
    var url: String
   
    
    init(name: String,city: String,age: String,image: UIImage,slider: Double,profession: String,company: String,dateOfBirth: String,email: String,gender: String,phone: String,placeAndDate: String,address: String,stat: String,id: String,url: String) {
        self.name = name
        self.city = city
        self.age = age
       self.image = image
        self.slider = slider
        self.profession = profession
        self.company = company
        self.dateOfBirth = dateOfBirth
        self.email = email
        self.gender = gender
        self.phone = phone
        self.placeAndDate = placeAndDate
        self.address = address
        self.stat = stat
        self.id = id
        self.url = url
        
    }
    
    
    
    
}
