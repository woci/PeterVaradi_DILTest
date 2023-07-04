//
//  TimerService.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 07. 04..
//

import Foundation

protocol TimerService: Injectable {
    func scheduledTimer(withTimeInterval: TimeInterval, repeats: Bool, block: @escaping @Sendable (Timer) -> Void) -> Timer
}
