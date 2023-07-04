//
//  SchedulerService.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 07. 04..
//

import Foundation

protocol SchedulerService: Injectable {
    func scheduleDrawing(drawing: Drawing)
    var delegate: SchedulerDelegate? { get set }
}
