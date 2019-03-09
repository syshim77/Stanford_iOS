//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by sooyeon Shim on 11/02/2019.
//  Copyright © 2019 sooyeon Shim. All rights reserved.
//

import UIKit

class EmotionsViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    // MARK: Model
    private var emotionalFaces: [(name: String, expression: FacialExpression)] = [
        ("Sad", FacialExpression(eyes: .Closed, eyeBrows: .Furrowed, mouth: .Frown)),
        ("Happy", FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile)),
        ("Worried", FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smirk)),
    ]
    
    @IBAction func addEmotionalFace(from segue: UIStoryboardSegue) {
        if let editor = segue.source as? ExpressionEditorViewController {
            emotionalFaces.append((editor.name, editor.expression))
            tableView.reloadData()
        }
    }
    
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emotionalFaces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Emotion Cell", for: indexPath)
        cell.textLabel?.text = emotionalFaces[indexPath.row].name
        return cell
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        if let faceViewController = destinationViewController as? FaceViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            faceViewController.expression = emotionalFaces[indexPath.row].expression
            faceViewController.navigationItem.title = emotionalFaces[indexPath.row].name
        } else if destinationViewController is ExpressionEditorViewController {
            if let popoverPresentationController = segue.destination.popoverPresentationController {
                popoverPresentationController.delegate = self
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        if traitCollection.verticalSizeClass == .compact {
            return .none
        } else if traitCollection.horizontalSizeClass == .compact {
            return .overFullScreen
        } else {
            return .none
        }
    }
    

}
