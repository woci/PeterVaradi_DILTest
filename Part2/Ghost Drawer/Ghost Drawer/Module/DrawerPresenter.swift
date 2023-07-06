//
//  DrawerPresenter.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 06. 30..
//

import Foundation

class DrawerPresenter: DrawerPresenterService {
    weak var view: DrawerView?
    var drawing: Drawing?
    var pencils: [Drawer]
    var scheduler: SchedulerService

    init(view: DrawerView? = nil, drawing: Drawing? = nil, pencils: [Drawer], scheduler: SchedulerService) {
        self.view = view
        self.drawing = drawing
        self.pencils = pencils
        self.scheduler = scheduler
    }

    func startDrawing(position: CGPoint, timeStamp: TimeInterval, pencilIndex: Int) {
        drawing = Drawing(points: [Point(position: position, timestamp: timeStamp)], pencil: pencils[pencilIndex])
    }

    func updateDrawing(position: CGPoint, timeStamp: TimeInterval) {
        drawing?.points.append(Point(position: position, timestamp: timeStamp))
    }

    func finishDrawing() {
        if let drawing = drawing {
            self.scheduler.scheduleDrawing(drawing: drawing)
        }
    }
}

extension DrawerPresenter: SchedulerDelegate {
    func draw(scheduledPath: ScheduledPath) {
        self.view?.render(scheduledPath: scheduledPath)
    }
}
