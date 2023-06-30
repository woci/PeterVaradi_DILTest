//
//  Pencil.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 06. 29..
//

import Foundation
import UIKit

protocol Drawable {
    var color: UIColor { get set }
    var delay: TimeInterval { get set }
}

struct Pencil: Drawable {
    var color: UIColor
    var delay: TimeInterval
}

struct Eraser: Drawable {
    var color: UIColor
    var delay: TimeInterval
}
