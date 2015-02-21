//
//  TweetComposeViewController.swift
//  Twitter
//
//  Created by Jeremy Hageman on 2/20/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class TweetComposeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetField: UITextField!
    
    let user = User.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = user?.name
        handleLabel.text = user?.screenname
        tweetField.placeholder = "What's happening?"
        tweetField.becomeFirstResponder()
        tweetField.delegate = self
        
        let profileImgUrl = NSURL(string: user!.profileImageUrlBigger!)
        let placeholder = UIImage(named: "no_photo")
        
        let imageRequestSuccess = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, image : UIImage!) -> Void in
            self.profileImage.image = image;
            self.profileImage.alpha = 0
            self.profileImage.layer.cornerRadius = 4.0
            self.profileImage.clipsToBounds = true
            UIView.animateWithDuration(0.5, animations: {
                self.profileImage.alpha = 1.0
            })
            
            self.profileImage.setImageWithURL(profileImgUrl)
        }
        let imageRequestFailure = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, error : NSError!) -> Void in
            NSLog("imageRequrestFailure")
        }
        
        let urlRequest = NSURLRequest(URL: profileImgUrl!)
        
        profileImage.setImageWithURLRequest(urlRequest, placeholderImage: placeholder, success: imageRequestSuccess, failure: imageRequestFailure)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelCompose(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onTweet(sender: AnyObject) {
        var tweetText = tweetField.text
        TwitterClient.sharedInstance.postNewTweet(tweetText, completion: { (tweet, error) -> () in
            if error != nil {
                println("post status update failed: \(error)")
            } else {
                
            }
            
        })
    }
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        
        let newLength = countElements(textField.text!) + countElements(string!) - range.length
        return newLength <= 10 //Bool
        
    }
}
