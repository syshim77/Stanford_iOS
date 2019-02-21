//
//  SmashTweetersTableViewController.swift
//  Smashtag
//
//  Created by sooyeon Shim on 22/02/2019.
//  Copyright © 2019 sooyeon Shim. All rights reserved.
//

import UIKit
import CoreData

class SmashTweetersTableViewController: FetchedResultsTableViewController {
    var mention: String? { didSet { updateUI() } }
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer   // container is good, context is not good
    { didSet { updateUI() } }
    
    var fetchedResultsController: NSFetchedResultsController<TwitterUser>?
    
    private func updateUI() {
        if let context = container?.viewContext, mention != nil {
            let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "handle", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))]
            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@ and !handle beginswith[c] %@", mention!, "MEC")
            fetchedResultsController = NSFetchedResultsController<TwitterUser>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try? fetchedResultsController?.performFetch()
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterUser Cell", for: indexPath)
        
        if let twitterUser = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = twitterUser.handle
            let tweetCount = tweetCountWithMentionBy(twitterUser)
            cell.detailTextLabel?.text = "\(tweetCount) tweet\((tweetCount == 1) ? "s" : "")"
        }
        
        return cell
    }
    
    private func tweetCountWithMentionBy(_ twitterUser: TwitterUser) -> Int {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "text contains[c] %@ and tweeter = %@", mention!, twitterUser)
        
        return (try? twitterUser.managedObjectContext!.count(for: request)) ?? 0
    }
}
