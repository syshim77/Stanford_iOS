## Chapter12 - Calculator

1. Autolayout
  - using the dashed blue lines to try to tell Xcode what you intend
  - Reset to Suggested Constraints -> Size Inspector(look at and edit the details of the constraints on the selected view) -> Attributes Inspector(click on a constraint to select it to edit its details)
  - ctrl-dragging -> "pin" and "arrange" menus
  - Document Outline
    + place to go to resolve conflicting constraints
  - Rotation
    + need to reposition the views to make them fit properly
    + ex) Calculator
  - Size Classes
    + environment for width and height
    + either compact or regular(i.e not compact)
    + iPhone
      * iPhones in Portrait are Compact in width and Regular in height
      * in Landscape, most iPhones are treated as Compact in both dimensions
    + iPhone Plus
      * orientation is also Compact in width and Regular in height
      * in Landscape, it is Compact in height and Regular in width
    + iPad
      * always Regular in both dimensions
      * MVC that is the master in a side-by-side split view will be Compact width, Regular height
    + Extensible
      * whole concept is extensible to any "MVC's inside other MVC's" situation(not just split view)
      * let mySizeClass: UIUserInterfaceSizeClass = self.traitCollection.horizontalSizeClass
