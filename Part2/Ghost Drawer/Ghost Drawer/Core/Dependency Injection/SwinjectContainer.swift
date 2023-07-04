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
        Renderer.register()
        Scheduler.register()
        DrawerPresenter.register()
        DrawerViewController.register()
//        ProfilePresenter.register()
//        RESTUserService.register()
//        ProfileUserService.register()
//        BUserService.register()
//        URLSession.register()
//        ImageLoader.register()
//
//        ProfileViewController.register()
//        BViewController.register()
    }

}
