//
//  Scheduler.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 06. 30..
//

import Foundation
import UIKit

protocol SchedulerDelegate: AnyObject {
    func draw(scheduledPath: ScheduledPath)
}

final class Scheduler: SchedulerService {
    /**
     timestamps:
     0----1----2----3----4----5----6----7----8----9----10----11----12----13
     |  G         |       B   |       R   |
     Red-1
     0----1----2----3----4----5----6----7----8----9----10----11----12----13
                           |     R    |
     Blue-3
     0----1----2----3----4----5----6----7----8----9----10----11----12----13
                        |      B    |
     Green-5
     0----1----2----3----4----5----6----7----8----9----10----11----12----13
                           |   G      |
     */
    var delegate: SchedulerDelegate?
    var timer: TimerService

    init(delegate: SchedulerDelegate? = Optional.none, timer: TimerService ) {
        self.delegate = delegate
        self.timer = timer
    }

    func scheduleDrawing(drawing: Drawing) {
        guard !drawing.points.isEmpty else {
            return
        }

        guard drawing.points.count > 1 else {
            let fromPoint = drawing.points[0]
            let scheduledPath = ScheduledPath(from: fromPoint.position,
                                                to: fromPoint.position,
                                                color: drawing.pencil.color,
                                                renderInterval: 0)

            schedule(timerToFire: drawing.pencil.delay, scheduledPath: scheduledPath)
            return
        }

        var timerToFire = drawing.pencil.delay
        for index in 0..<drawing.points.count {
            if index < drawing.points.count - 1 {
                let fromPoint = drawing.points[index]
                let toPoint = drawing.points[index + 1]
                let renderInterval = toPoint.timestamp - fromPoint.timestamp

                let scheduledPath = ScheduledPath(from: fromPoint.position,
                                                    to: toPoint.position,
                                                    color: drawing.pencil.color,
                                                    renderInterval: renderInterval)

                schedule(timerToFire: timerToFire, scheduledPath: scheduledPath)

                timerToFire += renderInterval
            }
        }
    }

    private func schedule(timerToFire: TimeInterval, scheduledPath: ScheduledPath) {
        let _ = timer.scheduledTimer(withTimeInterval: timerToFire, repeats: false) { timer in
            self.delegate?.draw(scheduledPath: scheduledPath)
        }
    }
}
