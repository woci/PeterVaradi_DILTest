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
            c.presenter = r.resolve(DrawerPresenterInput.self,
                                    name: DrawerPresenter.registeredName,
                                    argument: DrawerViewController.pencils)
            c.presenter.view = c
            c.renderer = r.resolve(RendererService.self,
                                   name: Renderer.registeredName,
                                   argument: c.canvas)
        }
    }

    private static var pencils: [Drawable] {
        [Pencil(color: .red, delay: 1.0), Pencil(color: .green, delay: 5.0), Pencil(color: .blue, delay: 3.0), Eraser(color: .white, delay: 2.0)]
    }
}
