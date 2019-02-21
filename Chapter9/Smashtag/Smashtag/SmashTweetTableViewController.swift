//
//  SmashTweetTableViewController.swift
//  Smashtag
//
//  Created by sooyeon Shim on 21/02/2019.
//  Copyright © 2019 sooyeon Shim. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class SmashTweetTableViewController: TweetTableViewController {
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        updateDatabase(with: newTweets)
    }
    
    private func updateDatabase(with tweets: [Twitter.Tweet]) {
        print("starting database load")
        container?.performBackgroundTask { [weak self] context in
            for twitterInfo in tweets {
                // add Tweet
                _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, in: context)
            }
            try? context.save()
            print("done loading database")
            self?.printDatabaseStatistics()
        }
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {   // viewContext is Main Queue context
            context.perform {   // off main thread -> on main thread
                if Thread.isMainThread {
                    print("on main thread")
                } else {
                    print("off main thread")
                }
                if let tweetCount = (try? context.fetch(Tweet.fetchRequest()))?.count {
                    print("\(tweetCount) tweets")
                }
                if let tweeterCount = try? context.count(for: TwitterUser.fetchRequest()) {
                    print("\(tweeterCount) Twitter users")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Tweeters Mentioning Search Term" {
            if let tweetersTVC = segue.destination as? SmashTweetersTableViewController {
                tweetersTVC.mention = searchText
                tweetersTVC.container = container
            }
        }
    }
}
