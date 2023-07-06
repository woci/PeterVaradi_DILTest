//
//  SwinjectContainer+register.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 07. 06..
//

import Foundation

extension SwinjectContainer {
    func registerDependencies() {
        ProxyTimer.register()
        Scheduler.register()
        DrawerPresenter.register()
        DrawerViewController.register()
    }
}
