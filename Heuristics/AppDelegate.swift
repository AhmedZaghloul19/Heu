//
//  AppDelegate.swift
//  Heuristics
//
//  Created by Ahmed Hussien on 2/7/18.
//  Copyright © 2018 Heuristic Gang. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        CURRENT_USER = User()
        CURRENT_USER?.userId = "1001"
        CURRENT_USER?.name = "Alisa Robert"
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
        UIApplication.shared.cancelAllLocalNotifications()
        return true
    }
    
    func handleEvent(forRegion region: CLRegion!) {
        // Show an alert if application is active
        if UIApplication.shared.applicationState == .active {
            guard let message = note(fromRegionIdentifier: region.identifier) else { return }
//            window?.rootViewController?.showAlert(withTitle: nil, message: message)
        } else {
            // Otherwise present a local notification
            guard let message = note(fromRegionIdentifier: region.identifier) else { return }
            let notification = UILocalNotification()
            notification.alertBody = message
            notification.soundName = "Default"
            UIApplication.shared.presentLocalNotificationNow(notification)
        }
    }
    
    func note(fromRegionIdentifier identifier: String) -> String? {
        let savedReminders = UserDefaults.standard.array(forKey: PreferencesKeys.savedItems) as? [NSData]
        let savedGeoMessages = UserDefaults.standard.array(forKey: PreferencesKeys.receivedMessages) as? [NSData]
        let geotificationsReminders = savedReminders?.map { NSKeyedUnarchiver.unarchiveObject(with: $0 as Data) as? Geotification }
        let geotificationsMessages = savedGeoMessages?.map { NSKeyedUnarchiver.unarchiveObject(with: $0 as Data) as? Geotification }
        let index = geotificationsReminders?.index { $0?.identifier == identifier }
        let geoMsgIndex = geotificationsMessages?.index { $0?.identifier == identifier }
        return index != nil ? geotificationsReminders?[index!]?.note : (geoMsgIndex != nil ? geotificationsMessages?[geoMsgIndex!]?.note : nil)
    }

}

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            print(region.identifier)
            handleEvent(forRegion: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            print(region.identifier)
            handleEvent(forRegion: region)
        }
    }
}
