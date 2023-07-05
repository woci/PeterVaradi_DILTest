//
//  SwinjectContainer.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 07. 04..
//

import Foundation
import Swinject

class SwinjectContainer {
    static let shared = SwinjectContainer()
    lazy var container = Container()
    private init() {}

    func registerDependencies() {
        ProxyTimer.register()
        Scheduler.register()
        DrawerPresenter.register()
        DrawerViewController.register()
    }
}
