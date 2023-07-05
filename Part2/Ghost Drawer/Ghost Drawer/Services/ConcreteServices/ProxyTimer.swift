//
//  ProxyTimer.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 07. 04..
//

import Foundation

final class ProxyTimer: TimerService {
    func scheduledTimer(withTimeInterval: TimeInterval, repeats: Bool, block: @escaping @Sendable (TimerService) -> Void) -> TimerService {
        Timer.scheduledTimer(withTimeInterval: withTimeInterval, repeats: repeats) { timer in
            block(self)
        }
        return self
    }
}
