## Chapter8 - Cassini

1. Multithreading
  - queues
    + functions(usually closures) are lined up in a queue
    + pulled off the queue and executed on an associated thread
    + serial: one at a time, concurrent: multiple things going at once
  - main queue
    + all UI activity must occur on this queue and this queue only
    + functions pulled off and worked on in this main queue only when it is "quiet"
  - other queues(i.e. not the main queue)
    + non-UI stuff
    + happen on a concurrent queue with a certain quality of service
      * QOS_CLASS_USER_INTERACTIVE: quick and high priority but lower than main queue
      * QOS_CLASS_USER_INITIATED: high priority, might take time
      * QOS_CLASS_UTILITY: long running
      * QOS_CLASS_BACKGROUND: user not concerned with this(prefetching, etc), lower priority
      * let queue = dispatch_get_global_queue(<one of the above>, 0)  // 0 is a "reserved for future"
  - own serial queue
    + if you need serialization
    + downloading a bunch of things from a certain website but don't want to deluge that website
    + depend on each other in a serial fashion
  - object-oriented API to all of this
    + NSOperationQueue and NSOperation
    + use non-object-oriented API a lot of the time
  - multithreaded iOS API
    ```swift
    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    if let url = NSURL(string: "http://url") {
      let request = NSURLRequest(URL: url)
      let task = session.downloadTaskWithRequest(request) { (localURL, response, error) in
        dispatch_async(dispatch_get_main_queue()) { }
      }
      task.resume()
    }
    ```
2. UITextField
  - like UILabel, but editable
    + mainstream UI element on iPad
  - keyboard appears when UITextField becomes first responder
    + automatically when the user taps on it
  - delegate can get involved with Return key, etc
    + func textFieldShouldReturn(sender: UITextField) -> Bool
  - finding out when editing has ended
    + func textFieldDidEndEditing(sender: UITextField)
  - Keyboard
    + controlling the appearance of the keyboard
      * set the properties defined in the UITextInputTraits protocol
    + keyboard comes up over other views
  - other UITextField functionality
    + left and right overlays
  - other keyboard functionality
    + var inputAccessoryView: UIView
