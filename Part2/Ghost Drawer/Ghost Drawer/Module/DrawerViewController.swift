//
//  DrawerViewController.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 06. 29..
//

import UIKit
import SwinjectStoryboard

protocol DrawerView: AnyObject {
    func render(scheduledPoint: ScheduledPoint)
}

class DrawerViewController: UIViewController, DrawerView {

    @IBOutlet weak var canvas: UIView!
    @IBOutlet weak var pencilSelector: UISegmentedControl!
    var renderer: RendererService!
    var presenter: DrawerPresenterInput!

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
          return
        }
        presenter.startDrawing(position: touch.location(in: canvas), timeStamp: event?.timestamp ?? .zero, pencilIndex: pencilSelector.selectedSegmentIndex)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
          return
        }
        presenter.updateDrawing(position: touch.location(in: canvas), timeStamp: event?.timestamp ?? .zero)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        presenter.finishDrawing()
    }
}

extension DrawerViewController {
    func render(scheduledPoint: ScheduledPoint) {
        renderer.render(scheduledPoint: scheduledPoint)
    }
}

extension DrawerViewController {
    static func create() -> DrawerViewController {
        let sb = SwinjectStoryboard.create(name: "Main",
                                           bundle: nil,
                                           container: SwinjectContainer.shared.container)
        let viewController = sb.instantiateViewController(withIdentifier: DrawerViewController.storyBoardIdentifier)
            as! DrawerViewController

        return viewController
    }
}

extension UIViewController {
    static var storyBoardIdentifier: String {
        String(describing: self) + "StoryboardIdentifer"
    }
}
