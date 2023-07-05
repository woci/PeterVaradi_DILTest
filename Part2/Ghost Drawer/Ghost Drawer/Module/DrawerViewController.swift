//
//  DrawerViewController.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 06. 29..
//

import UIKit
import SwinjectStoryboard

protocol DrawerView: AnyObject {
    func render(scheduledPath: ScheduledPath)
}

class DrawerViewController: UIViewController, DrawerView {

    @IBOutlet weak var canvas: UIView!
    @IBOutlet weak var pencilSelector: UISegmentedControl!
    var presenter: DrawerPresenterService!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

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
    func render(scheduledPath: ScheduledPath) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineCap = .round
        shapeLayer.lineWidth = 20
        shapeLayer.strokeColor = scheduledPath.color.cgColor

        let path = UIBezierPath()
        path.move(to: scheduledPath.from)
        path.addLine(to: scheduledPath.to)
        shapeLayer.path = path.cgPath

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = scheduledPath.renderInterval
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.isRemovedOnCompletion = false
        animation.fillMode = .both
        animation.isAdditive = false

        shapeLayer.add(animation, forKey: "fadeIn")
        self.canvas.layer.addSublayer(shapeLayer)
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
