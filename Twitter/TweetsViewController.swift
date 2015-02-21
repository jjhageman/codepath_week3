//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Jeremy Hageman on 2/17/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tweetView: UITableView!
    let tweetCellId = "tweetCellIdentifier"
    var refreshControl: UIRefreshControl!
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.navigationController?.navigationBarHidden = false
        self.tweetView?.dataSource = self
        self.tweetView?.delegate = self
        self.tweetView?.estimatedRowHeight = 81.0
        self.tweetView?.rowHeight = UITableViewAutomaticDimension

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchTweets", forControlEvents: UIControlEvents.ValueChanged)
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = tweetView
        dummyTableVC.refreshControl = refreshControl
        
        fetchTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    @IBAction func onReply(sender: AnyObject) {
    }
    @IBAction func onRetweet(sender: AnyObject) {
    }
    @IBAction func onFavorite(sender: AnyObject) {
    }
    
    func fetchTweets() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            if tweets != nil {
                self.tweets = tweets
                self.tweetView?.reloadData()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            } else {
                
            }
            self.refreshControl.endRefreshing()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tweetDetailSegue" {
            let cell = sender as UITableViewCell
            if let indexPath = tweetView.indexPathForCell(cell) {
                let tweetController = segue.destinationViewController as TweetDetailViewController
                tweetController.tweet = self.tweets![indexPath.row]
                tweetView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tweetView.dequeueReusableCellWithIdentifier(tweetCellId, forIndexPath: indexPath) as TweetsTableViewCell

        if let tweet = tweets?[indexPath.row] {
            if let user = tweet.user as User! {
                cell.nameLabel.text = user.name
                cell.handleLabel.text = "@\(user.screenname!)"
                cell.tweetLabel.text = tweet.text
                
                if let imageUrl = user.profileImageUrlBigger {
                    let placeholder = UIImage(named: "no_photo")
                    
                    let imageRequestSuccess = {
                        (request : NSURLRequest!, response : NSHTTPURLResponse!, image : UIImage!) -> Void in
                        cell.userImage.image = image;
                        cell.userImage.alpha = 0
                        cell.userImage.layer.cornerRadius = 4.0
                        cell.userImage.clipsToBounds = true
                        UIView.animateWithDuration(0.5, animations: {
                            cell.userImage.alpha = 1.0
                        })
                        
                        cell.userImage.setImageWithURL(NSURL(string: imageUrl))
                    }
                    let imageRequestFailure = {
                        (request : NSURLRequest!, response : NSHTTPURLResponse!, error : NSError!) -> Void in
                        NSLog("imageRequrestFailure")
                    }
                    
                    let urlRequest = NSURLRequest(URL: NSURL(string: imageUrl)!)
                    
                    cell.userImage.setImageWithURLRequest(urlRequest, placeholderImage: placeholder, success: imageRequestSuccess, failure: imageRequestFailure)
                }
            }
        }
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = tweets {
            return (array.count > 20) ? 20 : array.count
        } else {
            return 0
        }
    }
}
