//
//  TweetComposeViewController.swift
//  Twitter
//
//  Created by Jeremy Hageman on 2/20/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class TweetComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetView: UITextView!
    
    let user = User.currentUser
    var inReplyToTweet: Tweet?
    var counterButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nav = self.navigationController?.navigationBar
        self.navigationItem.setRightBarButtonItems([navigationItem.rightBarButtonItem!, counterButton], animated: true)
        
        nameLabel.text = user?.name
        handleLabel.text = user?.screenname

        tweetView.delegate = self
        if let inReply = inReplyToTweet {
            tweetView.text = "@\(inReply.user?.screenname! as String!) "
        } else {
            tweetView.text = "What's happening?"
            tweetView.textColor = UIColor.lightGrayColor()
            tweetView.selectedTextRange = tweetView.textRangeFromPosition(tweetView.beginningOfDocument, toPosition: tweetView.beginningOfDocument)
        }
        tweetView.becomeFirstResponder()
        updateNavCounterCount()
        
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
        var tweetText = tweetView.text
        TwitterClient.sharedInstance.postNewTweet(tweetText, completion: { (tweet, error) -> () in
            if error != nil {
                println("post status update failed: \(error)")
            } else {
                
            }
            
        })
    }
    
    func updateNavCounterCount() {
        counterButton.title = String(140 - countElements(tweetView.text))
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if countElements(updatedText) == 0 {
            
            textView.text = "What's happening?"
            textView.textColor = UIColor.lightGrayColor()
            
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGrayColor() && countElements(text) > 0 {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        updateNavCounterCount()
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGrayColor() {
                textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            }
        }
    }
}
