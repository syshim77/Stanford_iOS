## Chapter10

1. Core Data
  - database
    + store large amounts of data or query and want it to be object-oriented
  - enter core data
    + object-oriented database
    + very, very powerful framework in iOS
  - way of creating an object graph backed by a database
    + usually backed by SQL
  - focus on visual schema
  - need NSManagedObjectContext to access all of this stuff in your code
  - getting the NSManagedObjectContext
    + get the context we need from the persistentContainer using its viewContext var
    + returns an NSManagedObjectContext suitable only for use on the main queue
    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    let context: NSManagedObjectContext = container.viewContext
  - convenience
    + add a static version to AppDelegate on persistentContainer
    + possibly even add static var on viewContext
  - inserting objects into the database
    ```swift
    let context = AppDelegate.viewContext
    let tweet: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "Tweet", into: context)
    ```
    + the Data Model that we just graphically built in Xcode
  - access attributes in an NSManagedObject instance
    + using the following two NSKeyValueCoding protocol methods
      * func value(forKey: String) -> Any?
      * func setValue(Any?, forKey: String)
  - key is an attribute name in your data mapping
  - value is whatever is stored (or to be stored) in the database
  - changes(writes) only happen in memory, until you save
    ```swift
    do {
      try context.save()
    } catch { // note, by default catch catches any error into a local variable called error
      // deal with error
    }
    ```
    + explicitly save any changes to a context, but note that this throws
    + **don't forget to save your changes any time you touch the database**
  - set/get using vars
    + create a subclass of NSManagedObject
    + get Xcode to generate all the code necessary to make this work
  - how do I access my entities with these subclasses?
    // let's create an instance of the Tweet Entity in the database
    let context = AppDelegate.viewContext
    if let tweet = Tweet(context: context) {
      tweet.text = "140 characters of pure joy"
      tweet.created = Date()
      let joe = TwitterUser(context: tweet.managedObjectContext)
      tweet.tweeter = joe
      tweet.tweeter.name = "Joe Schmo"
    }
    + setting the value of a relationship is no different than setting any other attribute value
    + this will automatically add this tweet to joe's tweets relationship too
    if let joesTweets = joe.tweets as? Set<Tweet> { // joe.tweets is an NSSet, thus as
      if joesTweets.contains(tweet) { print("yes!") } // yes!
    }
    + **every NSManagedObject knows the managedObjectContext it is in**
    + relationships can be traversed using "dot notation"
  - so much more
    + optimistic locking(deleteConflictsForObject)
    + rolling back unsaved changes
    + Undo/Redo
    + staleness(how long after a fetch until a refetch of an object is required?)
2. Scalar types
  - scalars
    + default attributes cone through as objects(e.g. NSNumber)
3. Deletion
  - deleting objects from the database is easy
    + managedObjectContext.delete(_ object: tweet)
  - prepareForDeletion
    + implement in our NSManagedObject subclass
4. Querying
  - 3 important things involved in creating an NSFetchRequest
    + entity to fetch(required)
    + NSSortDescriptors to specify the order in which the Array of fetched objects are returned
    + NSPredicate specifying which of those Entities to fetch(optional, default is all of them)
  - creating an NSFetchRequest
    ```swift
    let request: NSFetchRequest<Tweet> = Tweet.fetchRequest() // this is a rare circumstance where Swift cannot infer the type
    request.sortDescriptors = [sortDescriptor1, sortDescriptor2, ...]
    request.predicate = ...
    ```
  - NSSortDescriptor
    ```swift
    let sortDescriptor = NSSortDescriptor(
      key: "screenName", ascending: true,
      selector: #selector(NSString.localizedStandardCompare(_ :))  // can skip this
    )
    ```
    + selector: argument is just a method(conceptually) sent to each object to compare it to others
    + usually just compare: but for NSString there are other options
    + localizedStandardCompare commonly used for String, specialized for String
  - NSPredicate
    + use %@ (more like printf) rather than \(expression) to specify variable data
    + all be predicates for searches in the Tweet table only
    ```swift
    let searchString = "foo"
    let predicate = NSPredicate(format: "text contains[c] %@", searchString)
    let joe: TwitterUser = ...  // a TwitterUser we inserted or queried from the database
    let predicate = NSPredicate(format: "tweeter = %@ && created > %@", joe, aDate)
    let predicate = NSPredicate(format: "tweeter.screenName = %@", "CS193p")
    ```
    + predicate for an interesting search for TwitterUsers instead
    + used to find TwitterUsers(not Tweets) who have tweets that contain the string
    ```swift
    let predicate = NSPredicate(format: "tweets.text contains %@", searchString)
    ```
  - NSCompoundPredicate
    + use AND and OR inside a predicate string(e.g. "(name = %@) OR (title = %@)")
    + can combine NSPredicate objects with special NSCompoundPredicate
  - function predicates
    + @count is a function(there are others) executed in the database itself
  - executing the fetch
    ```swift
    let context = AppDelegate.viewContext
    let recentTweeters = try? context.fetch(request)
    ```
    + try?: try this and if it throws an error, just give me nil back, could use a normal try inside a do { } and catch errors if we were interested
  - faulting
    + the above fetch does not necessarily fetch any actual data
    + core data is very smart about faulting the data in as it is actually accessed
5. Core Data thread safety
  - NSManagedObjectContext is not thread safe
    + core data access is usually very fast, so multithreading is only rarely needed
    + NSManagedObjectContexts are created using a queue-based concurrency model
  - thread-safe access to an NSManagedObjectContext
    ```swift
    context.performBlock { // or performBlockAndWait until it finishes
      // do stuff with context(this will happen in its safe Q(the Q it was created on))
    }
    ```
    + generally a good idea to wrap all your core data code using this
  - convenient way to do database stuff in the background
    ```swift
    AppDelegate.persistentContainer.performBackgroundTask { context in
      // do some CoreData stuff using the passed-in context
      // this closure is not the main queue, so don't do UI stuff here(dispatch back if needed)
      // and don't use AppDelegate.viewContext here, use the passed context
      // you don't have to use NSManagedObjectContext's perform method here either
      // since you're implicitly doing this block on that passed context's thread
      try? context.save() // don't forget this(and catch errors if needed)
    }
    ```
    + generally only be needed if you're doing a big update
    + for small queries and small updates, doing it on the main queue is fine
6. Core Data and UITableView
  - NSFetchedResultsController
    + hooks an NSFetchRequest up to a UITableViewController
    + use an NSFRC to answer all of your UITableViewDataSource protocol's questions
  - implementation of UITableViewDataSource
    ```swift
    var fetchedResultsController = NSFetchedResultsController // more on this in a moment
    func numberOfSectionsInTableView(sender: UITableView) -> Int {
      return fetchedResultsController?.sections?.count ?? 1
    }
    func tableView(sender: UITableView, numberOfRowsInSection section: Int) -> Int {
      if let sections = fetchedResultsController?.sections, sections.count > 0 {
        return sections[section].numberOfObjects
      } else {
        return 0
      }
    }
    func tableView(_ tv: UITableView, cellForRowAt indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tv.dequeue...
      if let obj = fetchedResultsController.object(at: indexPath) {
        // load up the cell based on the properties of the obj
        // obj will be an NSManagedObject (or subclass thereof) that fetches into this row
      }
      return cell
    }
    ```
  - create an NSFetchedResultsController
    + just need the NSFetchRequest to drive it(and a NSManagedObjectContext to fetch from)
    + be sure that any cacheName you use is always associated with exactly the same request
    + it's okay to specify nil for the cacheName(no cacheing of fetch results in that case)
    + if keyThatSaysWhichAttributesIsTheSectionName is nil, your table will be one big section
  - NSFetchedResultsController also watches core data
    + automatically will notify your UITableView if something changes that might affect it
  - things to remember to do
    + subclass fetchedResultsController to get NSFetchedResultsControllerDelegate
    + add a var called fetchedResultsController initialized with the NSFetchRequest you want
    + implement your UITableViewDataSource methods using this fetchedResultsController var
  - after you set the value of your fetchedResultsController
    ```swift
    try? fetchedResultsController?.performFetch() // would be better to catch errors!
    tableView.reloadData()
    fetchedResultsController?.delegate = self // inherit from FetchedResultsTableViewController
    ```
