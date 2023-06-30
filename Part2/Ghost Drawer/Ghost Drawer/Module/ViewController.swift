//
//  ViewController.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 06. 29..
//

import UIKit

protocol View: AnyObject {
    func render(scheduledPoint: ScheduledPoint)
}

class ViewController: UIViewController, View {

    @IBOutlet weak var canvas: UIView!
    @IBOutlet weak var pencilSelector: UISegmentedControl!
    var renderer: Renderer!
    var presenter: DrawerPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = DrawerPresenter(view: self)
        renderer = Renderer(canvas: canvas)
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

extension ViewController {
    func render(scheduledPoint: ScheduledPoint) {
        renderer.render(scheduledPoint: scheduledPoint)
    }
}

