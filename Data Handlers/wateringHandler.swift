//
//  wateringEditTracker.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 10/30/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import Foundation
import SwiftUI
import CloudKit
import UserNotifications

class handleWaterFert: ObservableObject{
    @Environment(\.managedObjectContext) var moc
    
    func checkAuthorizationStatus(plant:Plant, logType:String){
        UNUserNotificationCenter.current().getNotificationSettings { [self] settings in
                switch settings.authorizationStatus {
                case .notDetermined:
                    self.requestAuthorization()
                case .authorized, .provisional:
                    createReminder(for: plant, logType: logType)
                default:
                    break // Do nothing
                }
        }
    }
    
    //Ask user for authorization to give alerts
    func requestAuthorization(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // method for creating a reminder based on the type of action by user and on plant item(Watering or Fertilizing)
    func createReminder(for plantItem: Plant, logType: String){
        let content = UNMutableNotificationContent()
        let stringName = plantItem.name ?? "Your plant"
        
        // Check which type of log, water or fertilize
        if logType == "Water Log"{
            // Set all title and subtitle
            content.title = "Time to Water"
            content.subtitle = "\(stringName) looks thirsty!"
        }
        else {
            // Set all title and subtitle
            content.title  = "Time to Fertilize"
            content.subtitle = "\(stringName) looks hungry!"
        }
        
        content.sound = UNNotificationSound.default
        
        var dateComp = DateComponents()
        dateComp.calendar = Calendar.current
        var finalTriggerDate: DateComponents
        
        if logType == "Water Log"{
            dateComp.day = Int(plantItem.watering)
            dateComp.day! += 1
            print("plantFert: \(plantItem.watering)")
            print("dateComp: \(dateComp)")
            guard let triggerDate = dateComp.calendar?.date(byAdding: dateComp, to: Date()),
                  let triggerDateComponents  = dateComp.calendar?.dateComponents([.day, .hour, .minute, .second], from: triggerDate) else {
                return
            }
            finalTriggerDate = triggerDateComponents
        }
        else{
            dateComp.day = Int(plantItem.fertilize)
            dateComp.day! += 1
            print("plantFert: \(plantItem.fertilize)")
            print("dateComp: \(dateComp)")
            guard let triggerDate = dateComp.calendar?.date(byAdding: dateComp, to: Date()),
                  let triggerDateComponents  = dateComp.calendar?.dateComponents([.day, .hour, .minute, .second], from: triggerDate) else {
                return
            }
            finalTriggerDate = triggerDateComponents
        }
        
        // show this notification in X days (X being the number of days between watering specified by user on
        let trigger = UNCalendarNotificationTrigger(dateMatching: finalTriggerDate, repeats: false)
        print(finalTriggerDate)
        // choose plant id as identifier
        let id = plantItem.identifier?.uuidString
        let request = UNNotificationRequest(identifier: id!, content: content, trigger: trigger)
        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    // Cancels based on plant Identifier
    func cancelReminders(_ plantItem: Plant){
        let id = plantItem.identifier?.uuidString
        let notificationToRemove = [id!]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notificationToRemove)
    }
    
    // Cancels based on plantID and reminder day
    func cancelReminders(_ plantItem: Plant, _ day: String){
        let id = "\(plantItem.identifier!.uuidString).\(day)"
        let notificationToRemove = [id]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notificationToRemove)
    }
    
    // Create record based on list item from icloud and type of record to update
    func createReminder(_ record: ListElement, logType: String){
        let content = UNMutableNotificationContent()
        let stringName = record.name
        
        // Check which type of log, water or fertilize
        if logType == "Water Log"{
            // Set all title and subtitle
            content.title = "Time to Water"
            content.subtitle = "\(stringName) looks thirsty!"
        }
        else {
            // Set all title and subtitle
            content.title  = "Time to Fertilize"
            content.subtitle = "\(stringName) looks hungry!"
        }
        
        content.sound = UNNotificationSound.default
        
        var dateComp = DateComponents()
        dateComp.calendar = Calendar.current
        var finalTriggerDate: DateComponents
        
        if logType == "Water Log"{
            dateComp.day = Int(record.watering)
            dateComp.day! += 1
            print("plantFert: \(record.watering)")
            print("dateComp: \(dateComp)")
            guard let triggerDate = dateComp.calendar?.date(byAdding: dateComp, to: Date()),
                  let triggerDateComponents  = dateComp.calendar?.dateComponents([.day, .hour, .minute, .second], from: triggerDate) else {
                return
            }
            finalTriggerDate = triggerDateComponents
        }
        else{
            dateComp.day = Int(record.fertilizing)
            dateComp.day! += 1
            print("plantFert: \(record.fertilizing)")
            print("dateComp: \(dateComp)")
            guard let triggerDate = dateComp.calendar?.date(byAdding: dateComp, to: Date()),
                  let triggerDateComponents  = dateComp.calendar?.dateComponents([.day, .hour, .minute, .second], from: triggerDate) else {
                return
            }
            finalTriggerDate = triggerDateComponents
        }
        
        // show this notification in X days (X being the number of days between watering specified by user on
        let trigger = UNCalendarNotificationTrigger(dateMatching: finalTriggerDate, repeats: false)
        print(finalTriggerDate)
        // choose plant id as identifier
        let id = record.recordID
        let request = UNNotificationRequest(identifier: id!, content: content, trigger: trigger)
        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    // Create Reminder based on week schedule
    func checkSchedule(_ plantItem: Plant, _ day: String){
        if day == ""{
            let weeklySchedule : Dictionary<String, Bool> = ["sunday": plantItem.sunday, "monday":plantItem.monday, "tuesday":plantItem.tuesday, "wednesday":plantItem.wednesday, "thursday":plantItem.thursday, "friday":plantItem.friday, "saturday":plantItem.saturday]
            
            for (key, value) in weeklySchedule{
                if value{
                    createDayReminder(key, plantItem)
                }
            }
        }
        else{
            createDayReminder(day, plantItem)
        }
    }
    
    // Check plant schedule, create reminder repeating on specific day and time of the week
    func createDayReminder(_ day: String, _ plant: Plant){
        var dayInt = 0
        
        switch day {
        case "sunday":
            dayInt = 1
        case "monday":
            dayInt = 2
        case "tuesday":
            dayInt = 3
        case "wednesday":
            dayInt = 4
        case "thursday":
            dayInt = 5
        case "friday":
            dayInt = 6
        case "saturday":
            dayInt = 7
        default:
            dayInt = 4
        }
        
        
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.hour = 9
        components.weekday = dayInt
        components.timeZone = .current
        components.calendar = calendar
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Time to Water!"
        content.body = "\(String(describing: plant.name!)) is thirsty!"
        content.sound = UNNotificationSound.default
        
        let id = "\(plant.identifier!.uuidString).\(day)"
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error{
                print("Unable to create reminder: \(error)")
            }
        }
    }
    
    
//    func cancelReminderForRecord(_ recordID: String){
//        let notificationToRemove = [recordID]
//        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notificationToRemove)
//    }
}
