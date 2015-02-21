//
//  TwitterClient.swift
//  Twitter
//
//  Created by Jeremy Hageman on 2/16/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

let twitterConsumerKey = "bReJiEWhUaMWWkDMsgq9uoha0"
let twitterConsumerSecret = "bphUmOJurBVsyV82TpHSBj0pSYtuAJz51cxvU7ZHaU9dJf6wVM"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance : TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func postNewTweet(tweetText: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/update.json", parameters: ["status": tweetText], success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as NSDictionary)
            completion(tweet: tweet, error: nil)
        }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            completion(tweet: nil, error: error)
        })
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            completion(tweets: tweets, error: nil)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("error getting home timeline: \(error.userInfo)")
            completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token and redirect to  authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterapp://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            println("Got the request token")
            let authUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authUrl!)
        }) { (error: NSError!) -> Void in
            println("Failed to get request token: \(error)")
            self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openUrl(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: {(accessToken: BDBOAuth1Credential!) ->
            Void in
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var user = User(dictionary: response as NSDictionary)
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error: \(error)")
                self.loginCompletion?(user: nil, error: error)
            })
            
        }) { (error: NSError!) -> Void in
            println("Failed to receive access token: \(error)")
            self.loginCompletion?(user: nil, error: error)
        }
    }
}