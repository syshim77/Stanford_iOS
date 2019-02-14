## Chapter7 - Calculator, Cassini

1. Memory management
  - automatic reference counting
    + reference types(classes) are stored in the heap
  - influencing ARC
    + strong
      * normal reference counting
      * default
    + weak
      * if no one else is interested in this, then neither am I, set me to nil in that case
      * only applies to optional pointers
      * never keep an object in the heap
      * ex) outlets
    + unowned
      * don't reference count this
      * very rarely used
2. Closures
  - capturing
    + stored in the heap as well(i.e. they are reference types)
    + can be put in Arrays, Dictionarys, etc
    + first-class type in Swift
  - memory cycles
    + problem: pointing to each other
    + ex) UnaryOperation to be added to the CalculatorBrain
      * func addUnaryOperation(symbol: String, operation: (Double) -> Double)
      * "red square root" operation added, do square root but it will also turn the display red
  - how do we break this cycle?
    + Swift lets you control this capture behavior
    ```swift
    addUnaryOperation("red root") { [ unowned me = self ] in // unowned me = self -> weak weakSelf = self
      me.display.textColor = UIColor.redColor() // me.display -> weakSelf?.display
      return sqrt($0)
    }
    ```
3. Extensions
  - extending existing data structures
    + add methods/properties to a class/struct/enum (even if you don't have the source)
    + ex1) adds a method contentViewController to UIViewController
      * extension UIViewController { var contentViewController: UIViewController {...} }
    + ex2) clean up prepareForSegue code
      * if let myvc = segue.destinationViewController.contentViewController as ? MyVC {...}
  - be careful because it can be abused(easily abused)
    + have to be used object-oriented fashion
    + best used for very small, well-contained helper functions
    + be used well to organize code but requires architectural commitment
  - some restrictions
    + can't re-implement methods or properties that are already there (only add new ones)
    + can have no storage associated with them (computed only)
4. **Protocols**
  - way to express an API more concisely
    + implement certain methods and/or properties that the API wants
    + collection of method and properly declarations
  - type
    + used: vars, function parameters, etc
  - implementation of a protocol's methods and properties
    + provided by an implementing type
    + have no storage associated with it
    + add implementation to a protocol via an extension to that protocol
  - 4 aspects
    + the protocol declaration (what properties and methods are in the protocol)
    + the declaration where a class, struct or enum claims that it implements a protocol
    + the code that implements the protocol in said class, struct or enum
    + optionally, an extension to the protocol which provides some default implementation
  - optional methods in a protocol
    + mark some methods in a protocol optional
    + marked @objc means it follows Objective-C
    + optional-protocol implementing class must inherit from NSObject
    + part of Objective-C
  - declaration of the protocol it self
    + implements SomeProtocol must also implement InheritedProtocol1 and 2
    + must specify whether a property is get only or both get and set
    + functions that are expected to mutate the receiver should be marked mutating
    + can even specify initializers
  - how an implementer says "I implement that protocol"
    + listed after the superclass for a class
    + no limit on the number of protocol implemented
    + in a class, inits must be marked required
    + allowed to add protocol conformance via an extension
5. Delegation
  - very important use of protocols
    + way to implement "blind communication" between a View and its Controller
    + View -> Controller: delegate, data source
  - how it plays out
    + a view declares a delegation protocol(i.e. what the View wants the Controller to do for it)
    + the View's API has a weak delegate property whose type is that delegation protocol
    + the View uses the delegate property to get/do things it can't own or control on its own
    + the Controller declares that it implements the protocol
    + the Controller sets self as the delegate of the View by setting the property in number 2 above
    + the Controller implements the protocol (probably it has lots of optional methods in it)
  - the View is hooked up to the Controller
    + but still has no idea what the Controller is
  - this mechanism is found throughout iOS
    + but designed pre-closures in Swift
    + closures are often a better option
  - ex) UIScrollView
    + vertically, horizontally scrolled
    + adding subviews to a UIScrollView
    ```swift
    scrollView.contentSize = CGSize(width: 3000, height: 2000)
    logo.frame = CGRect(x: 2700, y: 50, width: 120, height: 180)
    scrollView.addSubview(logo)
    aerial.frame = CGRect(x: 150, y: 200, width: 2500, height: 1600)
    scrollView.addSubview(aerial)
    ```
    + scrolling in a UIScrollView
    + positioning subviews in a UIScrollView
    ```swift
    aerial.frame = CGRect(x: 0, y: 0, width: 2500, height: 1600)
    logo.frame = CGRect(x: 2300, y: 50, width: 120, height: 180)
    scrollView.contentSize = CGSize(width: 2500, height: 1600)  // easy to miss
    ```
    + that's it!
    + where in the content is the scroll view currently positioned?
    ```swift
    let upperLeftOfVisible: CGPoint = scrollView.contentOffset  // in the content area's coordinate system
    ```
    + what area in a UIView is currently visible?
    ```swift
    let visibleRect: CGRect = aerial.convertRect(scrollView.bounds, fromView: scrollView)
    ```
    + how do you create one?
      * drag out in a storyboard or use UIScrollView(frame:)
      * in code using addSubview
    + **don't forget contentSize!**
    + scrolling programmatically
      * func scrollRectToVisible(CGRect, animated: Bool)
    + zooming
      * affect the scroll view's contentSize and contentOffset
      * will not work without minimum/maximum zoom scale being set
    ```swift  
    scrollView.minimumZoomScale = 0.5 // 0.5 means half its normal size
    scrollView.MaximumZoomScale = 2.0 // 2.0 means twice its normal size
    ```
      * will not work without delegate method to specify view to zoom
    ```swift
    func viewForZoomingInScrollView(sender: UIScrollView) -> UIView
    ```
      * zooming programmatically
    ```swift
    var zoomScale: CGFloat
    func setZoomScale(CGFloat, animated: Bool)
    func zoomToRect(CGRect, animated: Bool)
    ```
    + lots of delegate methods
      * ex) func scrollViewDidEndZooming(UIScrollView, withView: UIView, atScale: CGFloat)
