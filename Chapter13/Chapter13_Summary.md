## Chapter13 - FaceIt

1. Timer
  - used to execute code periodically
  - run loops
    + only use Timer on the main queue
  - method
  ```swift
  class func scheduledTimer(
    withTimeInterval: TimeInterval,
    repeats: Bool,
    block: (Timer) -> Void
  ) -> Timer
  ```
  - example
  ```swift
  private weak var timer: Timer?  // weak var is okay because run loop will keep a strong pointer to this as long as it's scheduled
  timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) {
    // insert code here
  }
  ```
  - NSTimer
    + stopping a repeating timer
      * timer.invalidate()
    + tolerance
      * myOneMinuteTimer.tolerance = 10 // in seconds
      * firing time is relative to the start of the timer(i.e. no drift)
2. Animation
  - animating UIView properties
  - animating Controller transitions(as in a UINavigationController)
  - core animation
    + underlying powerful animation framework(also beyond the scope of this course)
  - OpenGL and Metal
    + 3D
  - SpriteKit
    + 2.5D
  - dynamic animation
    + physics-based animation
  - UIView animation
    + frame/center
    + transform(translation, rotation and scale)
    + alpha(opacity)
    + backgroundColor
  - done with UIView class method using closures
  - animation class method in UIView
  ```swift
  class func animate(withDuration: TimeInterval,
                            delay: TimeInterval,
                          options: UIViewAnimationOptions)
                       animations: () -> Void,
                       completion: ((finished: Bool) -> Void)?)
  ```
  - example
  ```swift
  if myView.alpha == 1.0 {
    UIView.animate(withDuration: 3.0,
                          delay: 2.0,
                        options: [.curveLinear],
                     animations: { myView.alpha = 0.0 },
                     completion: { if $0 { myView.removeFromSuperview() } })
    print("myView.alpha = \(myView.alpha)")
  }
  ```
  - use closures again with this UIView class method
  ```swift
  UIView.transition(with: UIView,
                duration: TimeInterval,
                 options: UIViewAnimationOptions,
              animations: () -> Void,
              completion: ((finished: Bool) -> Void)?)
  ```
  - example
  ```swift
  UIView.transition(with: myPlayingCardView,
                duration: 0.75,
                 options: [.transitionFlipFromLeft],
              animations: { cardIsFaceUp = !cardIsFaceUp },
              completion: nil)
  ```
  - animating changes to the view hierarchy is slightly different
    + UIViewAnimationOptions.showHideTransitionViews  // want to use the hidden properly
  - dynamic animation
    + steps
      * create a UIDynamicAnimator
      * add UIDynamicBehaviors to it(gravity, collisions, etc)
      * add UIDynamicItems(usually UIViews) to the UIDynamicBehaviors
    + behaviors
      * UIGravityBehavior
      * UIAttachmentBehavior
      * UICollisionBehavior
      * UISnapBehavior
      * UIPushBehavior
      * UIDynamicItemBehavior
      * UIDynamicBehavior
    + stasis
      * UIDynamicAnimator's delegate tells you when animation pauses
    + memory cycle avoidance
      * neither the action closure nor the pushBehavior can ever leave the heap
      * safe to mark unowned because if the action closure exists, so does the pushBehavior
