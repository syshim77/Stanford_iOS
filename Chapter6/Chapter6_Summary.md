## Chapter6 - FaceIt

1.  Segues
  - One MVC can cause another to appear
  - 4 kinds of segues(they will adapt to their environment)
    + Show segue: will push in a navigation controller, else modal
    + Show detail segue: will show in detail of a split view or will push in a navigation controller
    + Modal segue: take over the entire screen while the MVC is up
    + Popover segue: make the MVC appear in a little popover window
  - Always create a new instance of an MVC
    + This is important
    + The detail of a split view will get replaced with a new instance of that MVC
    + When you segue in a navigation controller it will not segue to some old instance, it'll be new
  - How do we make these segues happen?
    + ctrl-drag in a storyboard
    + black window: what kind of segue you want
    + line: segue(can set about segue in inspector)
    + identifier: most important in segue, naming(what the segue does)
  - What's that identifier all about?
    + invoke this segue from code using this UIViewController method
      * func performSegueWithIdentifier(identifier: String, sender: AnyObject?)
    + preparing for a segue
      * the method that is called in the instigator's Controller
      * func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
      * the segue passed in contains important information about this segue
      ```
      1) The identifier from the storyboard
      2) The Controller of the MVC you are segueing to (which was just created for you)
      ```
      * sender is either the instigating object or the sender
      * **this preparation is happening BEFORE outlets get set!**
  - Preventing segues
    + just implement this in your UIViewController
      * func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool
2. View Controller Lifecycle
  - A sequence of messages is sent to a View Controller as it progresses through its lifetime
  - Start of the lifecycle
    + creation
    + MVCs are most often instantiated out of a storyboard(as you've seen)
  - What then?
    + preparation if being segued to
    + outlet setting
    + appearing and disappearing
    + geometry changes
    + low-memory situations
  - After instantiation and outlet-setting, viewDidLoad is called
    + put a lot of setup code
    + better than init because your outlets are all set up by the time this is called
      * override func viewDidLoad()
    + update your UI from your Model
    + be careful because the geometry of your view is not set yet
      * do not initialize things that are geometry-dependent here
  - Just before your view appears on screen, you get notified
    + func viewWillAppear(animated: Bool) // animated is whether you are appearing over time
    + display is changing while your MVC is off-screen
    + to optimize performance by waiting until this method is called to kick off an expensive operation(probably in another thread)
    + view's geometry is set here, but there are other places to react to geometry
  - There is a "did" version of this as well
    + func viewDidAppear(animated: Bool)
  - And you get notified when you will disappear off screen too
    + remember what's going on and cleanup code
      * override func viewWillDisappear(animated:Bool)
  - There is a "did" version of this too
    + func viewDidDisappear(animated: Bool)
  - Geometry changed?
    + most of the time, this will be automatically handled with Autolayout
      * func viewWillLayoutSubviews()
      * func viewDidLayoutSubviews()
    + called any time a view's frame changed and this subviews were thus re-layed out
      * ex) autorotation
    + reset the frames of your subviews here or set other geometry-related properties
    + between "will" and "did", autolayout will happen
    + might be called more often than you'd imagine
      * so don't do anything in here that can't properly (and efficiently) be done repeatedly
  - Autorotation
    + UI changes shape when the user rotates the device between portrait/landscape
    + almost always, UI just responds naturally to rotation with autolayout
    + but, if you want to participate in the rotation animation, use this method below
      * func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator: UIViewControllerTransitionCoordinator)
      * coordinator: provide a method to animate alongside the rotation animation
  - Low-memory situations, didReceiveMemoryWarning gets called
    + ex) images and sounds
  - awakeFromNib
    + sent to all objects that come out of a storyboard(including your Controller)
    + happens before outlets are set!(i.e. before the MVC is "loaded")
    + put code somewhere else if at all possible(e.g. viewDidLoad or viewWillAppear)
  - Summary
    + instantiated(from storyboard usually)
    + awakeFromNib
    + segue preparation happens
    + outlets get set
    + viewDidLoad
    + viewWillAppear and viewDidAppear, viewWillDisappear and viewDidDisappear
      * called each time your Controller's view goes on/of screen
    + viewWillLayoutSubviews (... then autolayout happens, then ...) viewDidLayoutSubviews
      * geometry changed methods might be called at any time after viewDidLoad
