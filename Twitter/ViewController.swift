//
//  ViewController.swift
//  Twitter
//
//  Created by Jeremy Hageman on 2/16/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() {(user: User?, error: NSError?) in
            if error != nil {
                println("Login error: \(error)")
            } else {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
        }
    }

}

