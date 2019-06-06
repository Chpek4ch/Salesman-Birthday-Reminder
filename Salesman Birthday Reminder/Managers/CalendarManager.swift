//
//  CalendarManager.swift
//  Salesman Birthday Reminder
//
//  Created by Влад Карпенко on 08/04/2019.
//  Copyright © 2019 karpenko vlad. All rights reserved.
//

import Foundation
import EventKit

class CalendarManager {
    
    
    
    
    var exentStore = EKEventStore()
    let dateFormatterGet = DateFormatter()
    let year = Calendar.current.component(.year, from: Date())
    var startDateString = ""
    var endDateString = ""
    var savedEventId = ""
    
    //MARK: Public -
    
    public func addEventToCalendar(id: String,title: String, description: String?, startDate: String, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {

            self.dateFormatterGet.dateFormat = "yyyy/MM/dd HH:mm:ss"

            let dayAndMonth = startDate.prefix(5)

            self.startDateString =   "\(self.year)/" + "\(dayAndMonth)" + " " + "\(10):" + "\(00):" + "\(00)"
            self.endDateString =  "\(self.year)/" + "\(dayAndMonth)" + " " + "\(12):" + "\(00):" + "\(00)"


            let startDate = self.dateFormatterGet.date(from:self.startDateString)!
            let endDate = self.dateFormatterGet.date(from:self.endDateString)!


        let store = EKEventStore()
        store.requestAccess(to: .event) {(granted, error) in
            if !granted { return }
            var event = EKEvent(eventStore: store)
            event.title = title
            event.notes = description
            event.startDate = startDate
            event.endDate = endDate
            event.calendar = store.defaultCalendarForNewEvents
            do {
                try store.save(event, span: .thisEvent, commit: true)
                self.savedEventId = event.eventIdentifier //save event id to access this particular event later
                
                UserDefaults.standard.setValue(event.eventIdentifier, forKey: id)
            } catch {
                // Display error to user
            }
        }
    }
    
    
    public func checkEvent(id: String, title: String, description: String?, startDate: String) {

        var saveId = ""
        
        if let currentId = UserDefaults.standard.object(forKey: id) as? String {
            saveId = currentId
        } else {
            self.addEventToCalendar(id: id, title: title, description: description, startDate: startDate)
            return
        }
        
        let store = EKEventStore()
        store.requestAccess(to: .event) {(granted, error) in
            if !granted { return }
            let eventToRemove = store.event(withIdentifier: saveId)
            if eventToRemove == nil {
               
            self.addEventToCalendar(id: id, title: title, description: description, startDate: startDate)
            print("create")
            } else {
                 print("have") 
            }
        
    }
    }
        
    public func editEvent(id: String, title: String, description: String?, startDate: String){
        let saveId = UserDefaults.standard.object(forKey: id) as! String
        
        let store = EKEventStore()
        store.requestAccess(to: .event) {(granted, error) in
            if !granted { return }
            let eventToRemove = store.event(withIdentifier: saveId)
            if eventToRemove != nil {
                do {
                    try store.remove(eventToRemove!, span: .thisEvent, commit: true)
                    self.addEventToCalendar(id: id, title: title, description: description, startDate: startDate)
                } catch {
                    // Display error to user
                }
            }
        }
       
    
}

    public func deleteEvent(id: String){
        let saveId = UserDefaults.standard.object(forKey: id) as! String
        
        let store = EKEventStore()
        store.requestAccess(to: .event) {(granted, error) in
            if !granted { return }
            let eventToRemove = store.event(withIdentifier: saveId )
            if eventToRemove != nil {
                do {
                    try store.remove(eventToRemove!, span: .thisEvent, commit: true)
                } catch {
                    // Display error to user
                }
            }
        }
    }
    
}
