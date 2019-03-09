//
//  ViewController.swift
//  FaceIt
//
//  Created by sooyeon Shim on 2018. 7. 26..
//  Copyright © 2018년 sooyeon Shim. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    //MARK: Model
    var expression = FacialExpression(eyes: .Closed, eyeBrows: .Relaxed, mouth: .Smile) {
        didSet {
            updateUI()  // Model changed, so update the View
        }
    }
    
    //MARK: View
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.changeScale(recognizer:))
            ))
            
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseHappiness)
            )
            happierSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.decreaseHappiness)
            )
            sadderSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            updateUI()
        }
    }
    
    func updateUI() {
        if faceView != nil {
            switch expression.eyes {
            case .Open: faceView.eyesOpen = true
            case .Closed: faceView.eyesOpen = false
            case .Squinting: faceView.eyesOpen = false
            }
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
            faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        }
    }

    private var mouthCurvatures = [FacialExpression.Mouth.Frown: -1.0, .Grin: 0.5, .Smile: 1.0, .Smirk: -0.5, .Neutral: 0.0]
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Relaxed: 0.5, .Furrowed: -0.5, .Normal: 0.0]
    
    //MARK: Gesture Handlers
    @IBAction func toggleEyes(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: break
            }
        }
    }
    
    func changeBrows(recognizer: UIRotationGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            if recognizer.rotation > CGFloat(M_PI/4) {
                expression.eyeBrows = expression.eyeBrows.moreRelaxedBrow()
                recognizer.rotation = 0.0
            } else if recognizer.rotation < -CGFloat(M_PI/4) {
                expression.eyeBrows = expression.eyeBrows.moreFurrowedBrow()
                recognizer.rotation = 0.0
            }
        default:
            break
        }
    }
    
    private struct HeadShake {
        static let angle = CGFloat.pi/6                 // radians
        static let segmentDuration: TimeInterval = 0.5  // each head shake has 3 segments
    }
    
    private func rotateFace(by angle: CGFloat) {
        faceView.transform = faceView.transform.rotated(by: angle)
    }
    
    private func shakeHead() {
        UIView.animate(
            withDuration: HeadShake.segmentDuration,
            animations: { self.rotateFace(by: HeadShake.angle) },
            completion: { finished in
                if finished {
                    UIView.animate(
                        withDuration: HeadShake.segmentDuration,
                        animations: { self.rotateFace(by: -HeadShake.angle*2) },
                        completion: { finished in
                            UIView.animate(
                                withDuration: HeadShake.segmentDuration,
                                animations: { self.rotateFace(by: HeadShake.angle)
                    })
                })
            }
        })
    }
    
    @IBAction func shakeHead(_ sender: UITapGestureRecognizer) {
        shakeHead()
    }
    
    @objc func increaseHappiness() {
        expression.mouth = expression.mouth.happierMouth()
    }
    
    @objc func decreaseHappiness() {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
}

