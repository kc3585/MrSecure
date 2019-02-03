//
//  LoginViewController.swift
//  LastDitchProject
//
//  Created by Kevin Chen on 2/3/2019.
//  Copyright © 2019 New York University. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func signup(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!,    completion: { (user, error) in
            
            if user != nil {
                print("User Has Registered")
                let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "main") as! ViewController
                self.navigationController?.pushViewController(gameVC, animated: true)
            }
            if error != nil {
                print("BADDDDDDDD")
                print(error)
            }
            
        })
    }
    
    @IBAction func signin(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
            
            if user != nil {
                print("User Has Signed In")
                let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "main") as! ViewController
                self.navigationController?.pushViewController(gameVC, animated: true)
            }
            if error != nil {
                print("BADDDDD")
                print(error)
            }
            
        })
    }

}
