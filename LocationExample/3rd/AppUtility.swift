//
//  AppUtility.swift
//  LocationExample
//
//  Created by GeoSpark on 02/11/22.
//

import Foundation
import UserNotifications
import CoreLocation

func showNotification(_ loca:CLLocation, _ str:String,_ identifer:String){
    let content = UNMutableNotificationContent()
    content.title = str
    content.subtitle = "Location \(loca.description)"
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    let request = UNNotificationRequest(identifier: identifer, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}
