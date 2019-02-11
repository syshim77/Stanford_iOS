## Chapter4 - FaceIt

1. view
  - rectangular area
  - hierarchical
    * 보통은 graphical하게 처리
    * code로도 가능(addSubview(aView: UIView), removeFromSuperview())
    * start는 top view에서부터
    * top level view에서 bounds가 바뀜
  - 자식뷰가 부모뷰 밖으로 나올 수 있음
    * 겹치는 부분만 보여주거나 자식뷰 전체를 다 보여주거나
  - any number of subviews
  - order of subviews is important
  - initializing UIView
    * avoid initializer
      + if need, use init(frame: CGRect), init(coder: NSCoder)
      + func 하나 만들어서 모든 initialization code를 넣고 init 함수에서 그 함수 호출
      + or use awakeFromNib()
2. coordinate system data structures
  - CGFloat
    * let cfg = CGFloat(aDouble)
  - CGPoint
    * x, y가 있음
  - CGSize
    * width, height
  - CGRect
    * origin, size, midX, midY, many methods
  - view coordinate system
    * origin is upper left
    * drawing에 사용되는 모든 단위는 points(not pixels)
      + pixel을 신경쓰면 var contentScaleFactor: CGFloat 필요
    * 좌표계에서 내가 그린 그림에 대한 bounds
      + var bounds: CGRect
    * center, frame
      + frame: superview 안에 넣을 공간 정할 때 사용, view가 rotate 되었다면 그 view를 포함하는 가장 작은 사각형이 frame이 됨(따라서 view가 rotate 되었는지 알 수 없으므로 bound 사용)
      + center: superview의 좌표계에서 중심
3. custom views
  - override func drawRect(regionThatNeedsToBeDrawn: CGRect)
  - **NEVER** call drawRect
    * system will call
    * instead call setNeedsDisplay(), setNeedsDisplayInRect(regionThatNeedsToBeDrawn: CGRect)
  - core graphics concepts
    * need context to draw(UIGraphicsGetCurrentContext())
    * create paths(out of lines, arcs, etc)
    * set drawing attributes(colors, fonts, textures, linewidths, linecaps, etc)
    * stroke or fill the above-created paths
  - UIBezierPath
    * context, draw, set attributes, stroke, fill
    * not contain colors, fonts, texts, images
      + send to UIColor, NSAttributedString, preferredFont or system fonts or UIFont & UIFontDescriptor, UIImageView & UIImage
      + let green = UIColor.green: type method
      + let transparentYellow = UIColor.yellow.colorWithAlphaComponent(0.5): instance method
    * clipping(addClip()), hit detection(containsPoint(CGPoint)->Bool)
4. redraw on bounds
  - UIViewContentMode
    * left, right, top, bottom...
    * scale to fill, scale aspect fill, scale aspect fit
    * redraw
