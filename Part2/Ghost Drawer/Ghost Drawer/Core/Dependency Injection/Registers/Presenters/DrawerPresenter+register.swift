//
//  DrawerPresenter+register.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 07. 04..
//

import Foundation

extension DrawerPresenter {
    static func register() {
        SwinjectContainer.shared.container.register(DrawerPresenterService.self,
                                                    name: DrawerPresenter.registeredName) { r, pencils in
            let presenter = DrawerPresenter(pencils: pencils,
                                   scheduler: r.resolve(SchedulerService.self,
                                                        name: Scheduler.registeredName)!)
            presenter.scheduler.delegate = presenter
            return presenter
        }.implements(SchedulerDelegate.self)
    }
}
