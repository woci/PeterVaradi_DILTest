//
//  Scheduler.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 06. 30..
//

import Foundation
import UIKit

protocol SchedulerDelegate: AnyObject {
    func draw(scheduledPoint: ScheduledPoint)
}

struct Scheduler: SchedulerService {
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
        var timerToFire = drawing.pencil.delay
        for index in 0..<drawing.points.count {
            if drawing.points.count == 1 {
                let _ = timer.scheduledTimer(withTimeInterval: drawing.pencil.delay, repeats: false) { timer in
                    self.delegate?.draw(scheduledPoint: ScheduledPoint(from: drawing.points[index].position, to: drawing.points[index].position, color: drawing.pencil.color, renderInterval: 0))
                }
//                Timer.scheduledTimer(withTimeInterval: drawing.pencil.delay, repeats: false) { timer in
//                    timer.invalidate()
//                    self.delegate?.draw(scheduledPoint: ScheduledPoint(from: drawing.points[index].position, to: drawing.points[index].position, color: drawing.pencil.color, renderInterval: 0))
//                }
            } else {
                if index < drawing.points.count - 2 {
                    let fromPoint = drawing.points[index]
                    let toPoint = drawing.points[index + 1]
                    let renderInterval = toPoint.timestamp - fromPoint.timestamp
                    timerToFire += renderInterval

                    let _ = timer.scheduledTimer(withTimeInterval: timerToFire, repeats: false) { timer in
                        self.delegate?.draw(scheduledPoint: ScheduledPoint(from: fromPoint.position, to: toPoint.position, color: drawing.pencil.color, renderInterval: renderInterval))
                    }

//                    Timer.scheduledTimer(withTimeInterval: timerToFire, repeats: false) { timer in
//                        timer.invalidate()
//                        self.delegate?.draw(scheduledPoint: ScheduledPoint(from: fromPoint.position, to: toPoint.position, color: drawing.pencil.color, renderInterval: renderInterval))
//                    }
                }
            }
        }
    }
}
