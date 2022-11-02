//
//  AppDelegate.swift
//  LocationExample
//
//  Created by GeoSpark on 20/10/22.
//

import UIKit
import UserNotifications
import Roam

@main
class AppDelegate: UIResponder, UIApplicationDelegate ,RoamDelegate{
    



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        Roam.initialize("f87ed910afa43ef95adc0c29ff42350b961095cb2edd0e834001fa00938b6a5c")
        Roam.delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print(granted)
            print(error.debugDescription)
            if let error = error {
                print("D'oh: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func didUpdateLocation(_ locations: [RoamLocation]) {
        print(locations)
        showNotification(locations[0].location, "RoamSDK", "notification.id.01".random())
    }

}

