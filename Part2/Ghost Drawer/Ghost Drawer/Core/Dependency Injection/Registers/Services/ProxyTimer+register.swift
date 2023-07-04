//
//  ProxyTimer+regiszer.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 07. 04..
//

import Foundation

extension ProxyTimer {
    static func register() {
        SwinjectContainer.shared.container.register(TimerService.self,
                                                    name: ProxyTimer.registeredName) { r in
            return ProxyTimer()
        }
    }
}
