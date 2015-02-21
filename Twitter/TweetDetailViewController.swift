//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Jeremy Hageman on 2/19/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var tweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let tweetUnwrapped = self.tweet {
            if let user = tweetUnwrapped.user as User! {
                nameLabel.text = user.name
                handleLabel.text = "@\(user.screenname!)"
                tweetLabel.text = tweetUnwrapped.text
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "M/d/yy, h:mm a"
                let str = dateFormatter.stringFromDate(tweetUnwrapped.createdAt!)
                timestampLabel.text = str
                
                let profileImgUrl = NSURL(string: user.profileImageUrlBigger!)
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
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
