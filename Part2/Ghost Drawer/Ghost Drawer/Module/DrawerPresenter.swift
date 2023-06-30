//
//  DrawerPresenter.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 06. 30..
//

import Foundation

class DrawerPresenter {
    weak var view: View?
    var drawing: Drawing?
    var pencils: [Pencil]
    var scheduler: Scheduler

    init(view: View? = nil, drawing: Drawing? = nil, pencils: [Pencil] = [Pencil(color: .red, delay: 1.0), Pencil(color: .green, delay: 5.0), Pencil(color: .blue, delay: 3.0), Pencil(color: .white, delay: 2.0)], scheduler: Scheduler = Scheduler()) {
        self.view = view
        self.drawing = drawing
        self.pencils = pencils
        self.scheduler = scheduler
        self.scheduler.delegate = self
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

extension DrawerPresenter: SchedulerProtocol {
    func draw(scheduledPoint: ScheduledPoint) {
        self.view?.render(scheduledPoint: scheduledPoint)
    }
}
