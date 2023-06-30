//
//  Scheduler.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 06. 30..
//

import Foundation
import UIKit


protocol SchedulerProtocol {
    func draw(scheduledPoint: ScheduledPoint)
}

struct ScheduledPoint {
    var from: CGPoint
    var to: CGPoint
    var color: UIColor
    var renderInterval: TimeInterval
}

struct Scheduler {
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
    var delegate: SchedulerProtocol?

    init(delegate: SchedulerProtocol? = Optional.none) {
        self.delegate = delegate
    }

    func scheduleDrawing(drawing: Drawing) {
        var timerToFire = drawing.pencil.delay
        for index in 0..<drawing.points.count {
            if drawing.points.count == 1 {
                Timer.scheduledTimer(withTimeInterval: drawing.pencil.delay, repeats: false) { timer in
                    timer.invalidate()
                    self.delegate?.draw(scheduledPoint: ScheduledPoint(from: drawing.points[index].position, to: drawing.points[index].position, color: drawing.pencil.color, renderInterval: 0))
                }
            } else {
                if index < drawing.points.count - 2 {
                    let fromPoint = drawing.points[index]
                    let toPoint = drawing.points[index + 1]
                    let renderInterval = toPoint.timestamp - fromPoint.timestamp
                    timerToFire += renderInterval

                    Timer.scheduledTimer(withTimeInterval: timerToFire, repeats: false) { timer in
                        timer.invalidate()
                        self.delegate?.draw(scheduledPoint: ScheduledPoint(from: fromPoint.position, to: toPoint.position, color: drawing.pencil.color, renderInterval: renderInterval))
                    }
                }
            }
        }
    }
}
