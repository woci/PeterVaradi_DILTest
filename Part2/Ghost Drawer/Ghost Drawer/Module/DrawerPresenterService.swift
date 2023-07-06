//
//  DrawerPresenterService.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 07. 06..
//

import Foundation

protocol DrawerPresenterService: AnyObject, Injectable {
    var view: DrawerView? { get set }
    var drawing: Drawing? { get set }
    var pencils: [Drawer] { get set }
    var scheduler: SchedulerService { get set }
    func startDrawing(position: CGPoint, timeStamp: TimeInterval, pencilIndex: Int)
    func updateDrawing(position: CGPoint, timeStamp: TimeInterval)
    func finishDrawing()
}
