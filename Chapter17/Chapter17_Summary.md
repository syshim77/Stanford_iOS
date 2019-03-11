## Chapter17

1. Accessibility
  - 4 main types
    + learning literacy
    + physical motor skills
    + vision
    + hearing
  - properties in the protocols in Accessibility technology ask about
    + 5 main properties
      * isAccessibilityElement: Bool
      * accessibility: String?
      * accessibilityTraits: UIAccessibilityTraits  // important
      * accessibilityValue: String?
      * accessibilityHint: String?                  // important for first users
    ```swift
    class MyViewController: UIViewController {
      @IBOutlet weak var imageView: MyImageView!

      override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = "My Image Label"
        imageView.accessibilityTraits = UIAccessibilityTraitImage
      }
    }

    class MyImageView: UIView {
      override var isAccessibilityElement: Bool {
        get {
          return true
        }
        set { }
      }

      override var accessibilityLabel: String? {
        get {
          // return imageDescription()
          return "Question: \(questionLabel.text!), Answer: \(answerLabel.text!)"
        }
        set { }
      }

      override var accessibilityTraits: UIAccessibilityTraits {
        get {
          return super.accessibilityTraits | UIAccessibilityTraitButton
        }
        set { }
      }
    }
    ```
    ```swift
    class MyWeekView: UIView {
      override var isAccessibilityElement: Bool {
        get {
          return false
        }
        ...
      }
      ...
      var elements: [UIAccessibilityElement] = Array()
      for i in 1...numDaysInWeek {
        let element: UIAccessibilityElement = UIAccessibilityElement(accessibilityContainer: self)
        element.accessibilityLabel = nameForDay(i)
        element.accessibilityFrameInContainerSpace = axFrameForDay(i)
        elements.append(element)
      }
      accessibilityElements = elements
      ...
    }
    ```
  - vision accommodations
    + color
    + transparency and contrast
      * func UIAccessibilityDarkerSystemColorsEnabled() -> Bool
      * func UIAccessibilityIsReduceTransparencyEnabled() -> Bool
    + motion
      * func UIAccessibilityIsReduceMotionEnabled()
  - dynamic type
    + class func preferredFont(forTextStyle style: UIFontTextStyle) -> UIFont
    ```swift
    class MyLabelView: UIView {
      let label: UILabel

      required init?(coder aDecoder: NSCoder) {
        label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)

        super.init(coder: aDecoder)

        addSubview(label)
      }
    }
    ```
    + custom point sizes/fonts
      * var preferredContentSizeCategory: UIContentSizeCategory { get }
    ```swift
    class MyFontManager: NSObject {
      class func appFont() -> UIFont {
        var fontSize: CGFloat = 0.0
        let sizeCategory = UIApplication.shared.preferredContentSizeCategory
        switch(sizeCategory) {
          case .extraSmall:
            fontSize = 6.0
            break
          case .small:

          ...
        }
      ...
      }
      return UIFont.systemFont(ofSize: fontSize)
    }

    class MyViewController: UIViewController {
      override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.contentSizeCategoryChanged), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)

      }

      func contentSizeCategoryChanged() {
        updateLabelFonts()
      }
    }
    ```
2. Demo
  - VoiceOver
  - Accessibility Attributes
  - Accessibility Containers
