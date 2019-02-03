//
//  ViewController.swift
//  LastDitchProject
//
//  Created by Kevin Chen on 2/2/2019.
//  Copyright © 2019 New York University. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class ViewController: UIViewController {
    
    var timer = Timer()
    /** 8252
    // Make method trackChanges run every second
    var helloWorldTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(trackChanges), userInfo: nil, repeats: true)
    **/
    var count = 0
    // if !snapshot.exists() { return }
    @IBOutlet weak var trackNum: UITextField!
    @IBOutlet weak var dataPos: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        //createTimeIntervalNotification()
        
        /**
        // NEW
        let options: UNAuthorizationOptions = [.alert, .sound]
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: options, completionHandler: { (granted, error) in
            if !granted {
                print("Something is wrong")
            }
        })
        center.getNotificationSettings(completionHandler:  { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        })
         **/
 
        /**
         // OLD
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { didAllow, error in
            if didAllow {
                self.notify()
            }
            else {
                print("HALLLLLL")
            }
        })
        **/
        //self.notify()
        
        Database.database().reference(fromURL: "https://nodemcu-ace5b.firebaseio.com/").child("tracking_values").observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.count = Int(snapshot.childrenCount)
            
        }, withCancel: nil)
        
        //self.notify()
        timerStart()
        
        //print("Count " + String(count))
        
        /**
        Database.database().reference(fromURL: "https://lastditchproject.firebaseio.com/").child(String(1)).observe(.childAdded, with: { (snapshot) in
            
                print (snapshot)
                if (!snapshot.exists()) {
                    
                }
                else {
                    self.count += 1
                }
            
            }, withCancel: nil)
        **/
        
        /**
        // GOOD
        Database.database().reference(fromURL: "https://lastditchproject.firebaseio.com/").child(String(0)).observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot.exists())
            
            }, withCancel: nil)
        **/
        
        //var cont = false
        
        /**
        while (cont) {
            print("Count " + String(count))
            Database.database().reference(fromURL: "https://lastditchproject.firebaseio.com/").child(String(count)).observeSingleEvent(of: .value, with: { (snapshot) in
                print("HELLLLLLLLLO")
                if (!snapshot.exists()) {
                    cont = false
                }
                else {
                    self.count += 1
                }
                
            }, withCancel: nil)
        }
        **/
        
        //print("HELLLLLLLLLLLLLO " + String(self.count))
    }
    
    func timerStart () {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(trackChanges), userInfo: nil, repeats: true)
    }
    
    @objc func whatToDo() { // Helper to test if it repeats
        print("HELLO WORLD")
    }
    
    @objc func trackChanges() {
        //Tracking Changes
        //self.createTimeIntervalNotification()
        let database = Database.database().reference(fromURL: "https://nodemcu-ace5b.firebaseio.com/")
        let postRef = database.child("lastscan")
        postRef.observe(.childChanged, with: { (snapshot) -> Void in
            print("CHANGEDDDDDDDDDDDDDDDD")
            self.createTimeIntervalNotification()
        })
    }
    
    func notify() {
        
        // Notify for arrival of package
        /**
         // OLD
        let content = UNMutableNotificationContent()
        content.title = "Your Package has been Delivered"
        content.subtitle = "Hello World"
        content.body = "The delivery service has left your order in a safe location"
        content.badge = 0
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        **/
        
        /**
        // NEW
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Notification Title", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Message", arguments: nil)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
         **/
    }
    
    @IBAction func opTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    @IBAction func enter(_ sender: Any) {
        /**
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "main") as! LoginViewController
        self.navigationController?.pushViewController(gameVC, animated: true)
        **/
        let data = trackNum.text!
 
        /**
        Database.database().reference(fromURL: "https://lastditchproject.firebaseio.com/").child(String(count)).updateChildValues([count:data])
        **/
        let ref = Database.database().reference(fromURL: "https://nodemcu-ace5b.firebaseio.com/").child("tracking_values")
        
        let values:[AnyHashable : Any]
        
        if (self.dataPos.text! == "") {
            values = [String(count):data]
        }
        else {
            values = [String(self.dataPos.text!):data]
        }
        
        // Completion block is used to tell you its completed
        ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            self.trackNum.text = ""
            self.dataPos.text = ""
        })
        
        count += 1
    }
    @IBAction func timeInterval(_ sender: Any) {
        createTimeIntervalNotification()
    }
    
    func createTimeIntervalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Your Package has arrived"
        content.body = "It is not being stolen"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "firstNotification", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: { (error) in
            print("error \(error)")
        })
    }
    
    func createDateInfoNotification() {
        let content = UNMutableNotificationContent()
        content.title = "DateInfo Notif"
        content.body = "Notification Message"
        content.sound = UNNotificationSound.default
        
        var dateInfo = DateComponents()
        dateInfo.hour = 20
        dateInfo.minute = 7
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
        
        let request = UNNotificationRequest(identifier: "dateNotification", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print("error \(error)")
        }
    }

}
