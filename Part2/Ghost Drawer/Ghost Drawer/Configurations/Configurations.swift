//
//  Configurations.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 07. 06..
//

import Foundation

struct Configurations {
    static var pencils: [Drawer] = [Pencil(color: .red, delay: 1.0),
                                    Pencil(color: .green, delay: 5.0),
                                    Pencil(color: .blue, delay: 3.0),
                                    Eraser(color: .white, delay: 2.0)]
}
