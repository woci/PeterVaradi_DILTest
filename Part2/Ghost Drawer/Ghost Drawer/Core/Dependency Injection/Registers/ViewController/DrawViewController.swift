//
//  DrawViewController.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 07. 04..
//

import Foundation
import SwinjectStoryboard

extension DrawerViewController: Injectable {
    static func register() {
        SwinjectContainer.shared.container.storyboardInitCompleted(DrawerViewController.self) { r, c in
            c.presenter = r.resolve(DrawerPresenterService.self,
                                    name: DrawerPresenter.registeredName,
                                    argument: Configurations.pencils)
            c.presenter.view = c
        }
    }
}
