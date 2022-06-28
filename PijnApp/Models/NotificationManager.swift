//
//  Notifications.swift
//  PijnApp
//
//  Created by Casper on 17/12/2021.
//

import Foundation
import UserNotifications

//Alles wat nodig is voor het weergeven van notificaties
class NotificationManager{
    
    static let instance = NotificationManager()
    
    func requestAuthorization(){
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                print("success")
            }
        }
    }
    
    func scheduleMorningNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Goedemorgen"
        content.body = "Hoe heb je geslapen vanacht?"
        content.sound = .default
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "morning", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleEveningNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Goedenavond"
        content.body = "Kun je wat meer vertellen over je dag?"
        content.sound = .default
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "evening", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
}
