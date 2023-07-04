//
//  Scheduler+regiszer.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 07. 04..
//

import Foundation

extension Scheduler {
    static func register() {
        SwinjectContainer.shared.container.register(SchedulerService.self,
                                                    name: Scheduler.registeredName) { r in
            return Scheduler(timer: r.resolve(TimerService.self, name: ProxyTimer.registeredName)!)
        }
    }
}
