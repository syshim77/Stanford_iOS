## Chapter15 - FaceIt

1. Segue
  - Modal View Controllers
    + a way of segueing that takes over the screen
    + ex) contacts application
    + considerations
      * take over the entire screen
      * can be rather disconcerting to the user, so use this carefully
    + ctrl-drag from a button to another View Controller & pick segue type "Modal"
    + present a Modal VC not from a button, use a manual segue
      * func performSegue(withIdentifier: String, sender: Any?)
    + have the view controller itself(e.g. Alerts or from instantiateViewController)
      * func present(UIViewController, animated: Bool, completion: (() -> Void)? = nil)
    + preparing for a modal segue
    ```swift
    func prepare(for: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "GoToMyModalVC" {
        let vc = segue.destination as MyModalVC
        // set up the vc to run here
      }
    }
    ```
    + dismiss a view controller
      * func dismiss(animated: Bool, completion: (() -> Void)? = nil)
      * unwind segues automatically dismiss
  - Unwind Segue
    + only segue that does NOT create a new MVC
    + good for
      * jumping up the stack of cards in a navigation controller(other cards are considered presenters)
      * dismissing a Modally segued-to MVC while reporting information back to the presenter
    + ctrl-drag to the "Exit" button in the same MVC
    + choose a special @IBAction method you've created in another MVC
      * means "segue by exiting me and finding a presenter who implements that method"
    + if the @IBAction can be found, you(i.e. the presented MVC) will get to prepare as normal
    + special @IBAction will be called in the other MVC and that MVC will be shown on screen
    + you will be dismissed in the process
  - Popover
    + Popovers pop an entire MVC over the rest of the screen
    + touching grayed out area dismiss popover
    + almost exactly the same as a Modal segue
    + preparing for a popover segue
      * all segues are managed via a UIPresentationController
      * popover's UIPopoverPresentationController
      * it notes what caused the popover to appear(a bar button item or just a rectangle in a view)
      * also control what direction the popover's arrow is allowed to point
      * or can control how a popover adapts to different sizes classes(e.g. iPad vs iPhone)
    + prepare(for segue:) that prepares for a Popover segue
    ```swift
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let identifier = segue.identifier {
        switch identifier {
          case "Do Something in a Popover Segue":
            if let vc = segue.destination as? MyController {
              if let ppc = vc.popoverPresentationController {
                ppc.permittedArrowDirections = UIPopoverArrowDirection.any
                ppc.delegate = self
              }
              // more preparation here
            }
          default: break
        }
      }
    }
    ```
    + Popover Presentation Controller
      * adaptation to different size classes
      * popover presentation controller's delegate can control this adaptation behavior
      * either by preventing it entirely
    ```swift
    func adaptivePresentationStyle(
      for controller: UIPresentationController,
      traitCollection: UITraitCollection
      ) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.non // don't adapt
        // the default in horizontally compact environments (iPhone) is .fullScreen
      }
    ```
      * wrapping a UINavigationController around the MVC that is presented
    ```swift
    func presentationController(controller: UIPresentationController,
      viewControllerForAdaptivePresentationStyle: UIModalPresentationStyle)
      -> UIViewController {
        // return a UIViewController to use(e.g. wrap a Navigation Controller around your MVC)
      }
    ```
    + Popover Size
      * important popover issue
      * var preferredContentSize: CGSize
  - Embed Segues
    + putting a VC's self.view in another VC's view hierarchy
    + drag out a Container View from the object palette into the scene you want to embed it in
    + automatically sets up an "Embed Segue" from container VC to the contained VC
    + works just like other segues
    + view loading timing
      * embedded VC's outlets are not set at the time prepare(for segue:, sender:) is called
