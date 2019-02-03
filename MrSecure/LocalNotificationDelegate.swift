//
//  LocalNotificationDelegate.swift
//  MrSecure
//
//  Created by Kevin Chen on 2/3/2019.
//  Copyright © 2019 New York University. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    func userNotificationCenter( _ center: UNUserNotificationCenter, didReceive responnse: UNNotificationResponse, withCompletedHandler completionHandler: @escaping () -> Void){
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound, .badge])
    }
    
}
