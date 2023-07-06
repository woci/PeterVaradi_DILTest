//
//  DrawerView.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 07. 06..
//

import Foundation

protocol DrawerView: AnyObject {
    func render(scheduledPath: ScheduledPath)
}
