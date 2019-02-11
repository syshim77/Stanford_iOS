## Chapter5 - FaceIt

1. gestures
  - input from the users on the screen
  - recognized by instances of UIGestureRecognizer
    * base class is abstract
  - 2 sides to using a gesture recognizer
    * adding a gesture recognizer to a UIView
    * providing a method to handle that gesture(UIGestureRecognizerHandler)
  - controller add gesture recognizers
    * except some views like scrollview
    * controller controls when influence to model
  - adding gesture recognizer to UIView
    * add to didSet
    * use #selector(get from object-C method), inherit from NSObject
  - implement gesture recognizer handler
   * state machine: start from .Possible or .Recognized or .Began
   * add into controller
  - pan, pinch, rotation, swipe, tap, etc
2. MVCs working together
  - MVC의 view가 다른 MVC의 view가 됨
    * iOS provides some controllers whose view is other MVCs: UITabBarController, UISplitViewController, UINavigationController
  - accessing the sub-MVCs
    * via the viewControllers property
      + var viewControllers: [UIViewController]? { get set }
      + tab bar: left to right
      + split view: 0 is master, 1 is detail
      + navigation controller: 0 is root, the rest are in order on the stack
    * can get ahold of the SVC, TBC or NC itself
  - wiring up MVCs
    * SVC: drag out a split view controller and delete all the extra VCs it brings with it -> ctrl-drag from SVC to the master and detail MVCs(but can only do on iPad)
