//
//  Renderer+register.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 07. 04..
//

import Foundation

extension Renderer {
    static func register() {
        SwinjectContainer.shared.container.register(RendererService.self,
                                                    name: Renderer.registeredName) { r, canvas in
            return Renderer(canvas: canvas)
        }
    }
}
