//
//  EyeView.swift
//  FaceIt
//
//  Created by sooyeon Shim on 06/03/2019.
//  Copyright © 2019 sooyeon Shim. All rights reserved.
//

import UIKit

class EyeView: UIView {
    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }
    var color: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    
    var _eyesOpen: Bool = true { didSet { setNeedsDisplay() } }
    
    var eyesOpen: Bool {
        get {
            return _eyesOpen
        }
        set {
            if newValue != _eyesOpen {
                UIView.transition(with: self, duration: 0.4, options: [.transitionFlipFromTop], animations: {
                    self._eyesOpen = newValue
                })
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        var path: UIBezierPath
        
        if eyesOpen {
            path = UIBezierPath(ovalIn: bounds.insetBy(dx: lineWidth/2, dy: lineWidth/2))
        } else {
            path = UIBezierPath()
            path.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        }
        
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
    }
}
