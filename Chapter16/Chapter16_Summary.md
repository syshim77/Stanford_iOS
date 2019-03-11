## Chapter16 - FaceIt

1. Alerts and Action Sheets
  - two kinds of "pop up and ask the user something" mechanisms
    + Alerts
    + Action Sheets
  - Alerts
    + pop up in the middle of the screen
    + usually ask questions with only two answers(e.g. OK/Cancel, Yes/No, etc)
    + can be disruptive to your user-interface, so use carefully
    + often used for "asynchronous" problems("connection reset" or "network fetch failed")
    + can have a text field to get a quick answer(e.g. password)
    ```swift
    var alert = UIAlertController(
      title: "Login Required",
      message: "Please enter your Cassini guidance system...",
      preferredStyle: .alert
    )

    alert.addAction(UIAlertAction(
      title: "Cancel",
      style: .cancel)
      { (action: UIAlertAction) -> Void in
          // do nothing
      }
    )

    alert.addAction(UIAlertAction(
      title: "Login",
      style: .default)
      { (action: UIAlertAction) -> Void in
          // get password and log in
      }
    )

    alert.addTextField(configurationHandler: { textField in
      textField.placeholder = "Guidance System Password"
    })
    ```
  - Action Sheets
    + usually slides in from the bottom of the screen on iPhone/iPad Touch, and in a popover on iPad
    + can be displayed from bar button item or from any rectangular area in a view
    + generally asks questions that have more than two answers
    + think of action sheets as presenting "branching decisions" to the user(i.e. what next?)
    ```swift
    var alert = UIAlertController(
      title: "Redeploy Cassini",
      message: "Issue commands to Cassini's guidance system.",
      preferredStyle: .actionSheet
    )

    alert.addAction(UIAlertAction(
      title: "Orbit Saturn",
      style: UIAlertActionStyle.default)
      { (action: UIAlertAction) -> Void in
          // go into orbit around saturn
      }
    )

    alert.addAction(UIAlertAction(
      title: "Explore Titan",
      style: .default)
      { (action: UIAlertAction) -> Void in
          if !self.loggedIn { self.login() }
          // if loggedIn go to titan
      }
    )

    alert.addAction(UIAlertAction(
      title: "Closeup of Sun",
      style: .destructive)
      { (action: UIAlertAction) -> Void in
          if !loggedIn { self.login() }
          // if loggedIn destroy Cassini by going to Sun
      }
    )

    alert.addAction(UIAlertAction(
      title: "Cancel",
      style: .cancel)
      { (action: UIAlertAction) -> Void in
          // do nothing
      }
    )

    alert.modalPresentationStyle = .Popover
    let ppc = alert.popoverPresentationController
    ppc?.barButtonItem = redeployBarButtonItem

    present(alert, animated: true, completion: nil)
    ```
2. Notification
  - Notifications
    + "radio station" from the MVC slides
    + for model(or global) to Controller communication
  - NotificationCenter
    + get the default "notification center" via NotificationCenter.default
    + send it the following message if you want to "listen to a radio station"
    ```swift
    var observer: NSObjectProtocol  // a cookie to later "stop listening" with
    observer = NotificationCenter.default.addObserver(
      forName: NSNotification.Name, // the name of the radio station
      object: Any?,                 // the broadcaster(or nil for "anyone")
      queue: OperationQueue?        // the queue on which to dispatch the closure below
    ) { (notification: Notification) -> Void in // closure executed when broadcasts occur
      let info: Any? = notification.userInfo
      // info is usually a dictionary of notification-specific information
    }
    ```
  - NSNotification.Name
    + you will see them as static vars on NSNotification.Name
    + can make your own radio station name with NSNotification.Name(String)
  - Example of listening to "radio station broadcasts"
    + watching for changes in the size of preferred fonts(user can change this in Settings)
    ```swift
    let center = NotificationCenter.default
    var observer = center.addObserver(
      forName: NSNotification.Name.UIContentSizeCategoryDidChange
      object: UIApplication.shared,
      queue: OperationQueue.main
    ) { notification in
      // re-set the fonts of objects using preferred fonts
      // or look at the size category and do something with it
      let c = notification.userInfo?[UIContentSizeCategoryNewValueKey]
      // c might be UIContentSizeCategorySmall, for example
    }
    center.removeObserver(observer) // when you're done listening
    ```
  - posting a Notification
    + any closures added with addObserver will be executed
    + either immediately on the same queue as post(if queue was nil)
    + or asynchronously by posting the block onto the queue specified with addObserver
    ```swift
    NotificationCenter.default.post(
      name: NSNotification.Name,          // name of the "radio station"
      object: Any?,                       // who is sending this notification(usually self)
      userInfo: [AnyHashable:Any]? = nil  // any info you want to pass to station listeners
    )
    ```
3. Application Lifecycle
  - Lifecycle
    + Not running
    + Foreground
      * Inactive
      * Active
    + Background
      * Background
    + Suspended
  - UIApplicationDelegate
  - UIApplication
    + Shared instance
    + Opening a URL in another application
    + Registering to receive Push Notifications
    + Setting the fetch interval for background fetching
    + Asking for more time when backgrounded
      * do NOT forget to call endBackgroundTask(UIBackgroundTaskIdentifier) when you're done!
    + Turning on the "network in use" spinner(status bar upper left)
    + Finding out about things
  - Info.plist
    + many of your application's settings are in Info.plist
  - Capabilities
    + some features require enabling
      * server and interoperability features
      * like iCloud, Game Center, etc
    + switch on in Capabilities tab
      * inside your Project Settings
4. Persistence
  - UserDefaults
    + only for little stuff
  - Core Data
  - Archiving
    + very rarely used for persistence, but it is how storyboards are made persistent
    + mechanism for making ANY objet graph persistent
      * not just graphs with Array, Dictionary, Date, etc. in them
    + requires all objects in the graph to implement NSCoding protocol
      * func encode(with aCoder: NSCoder)
      * init(coder: NSCoder)
  - SQLite
    + also rarely used unless you have a legacy SQL database you need to access
    + SQL in a single file
      * fast, low memory, reliable
      * open source, comes bundled in iOS
      * not good for everything(e.g. not video or even serious sounds/images)
      * not a server-based technology(not great at concurrency, but usually not a big deal on a phone)
      * API is "C like"(i.e. not object-oriented)
      * is used by Core Data
  - File System
    + iOS has a Unix filesystem underneath it
    + can read and write files into it with some restrictions
    + accessing files in the Unix filesystem
      * get the root of a path into an URL
      * append path components to the URL
      * write to/read from the files
      * manage the filesystem with FileManager
    + your application sees iOS file system like a normal Unix filesystem
    + and you can only write inside your application's "sandbox"
      * Security(so no one else can damage your application)
      * Privacy(so no other applications can view your application's data)
      * Cleanup(when you delete an application, everything it has ever written goes with it)
    + what's in this "sandbox"?
      * application bundle directory(binary, .storyboards, .jpgs, etc) -> NOT writeable
      * documents directory -> this is where you store permanent data created by the user
      * caches directory -> store temporary files here(this is not backed up by iTunes)
      * other directories
    + getting a path to these special sandbox directories
    ```swift
    let urls: [URL] = FileManager.default.urls(
      for directory: FileManager.SearchPathDirectory.documentDirectory,
      in domainMask: .userDomainMask
    )
    ```
    + URL
      * building on top of these system paths
      * finding out about what's at the other end of a URL
    + Data
      * reading/writing binary data to files
    + FileManager
      * provides utility operations
      * check to see if files exist; create and enumerate directories; move, copy, delete files; etc
      * thread safe(as long as a given instance is only ever used in one thread)
      * also has a delegate with lots of "should" methods(to do an operation or proceed after an error)
