//
//  Pencil.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 06. 29..
//

import Foundation
import UIKit

protocol Drawer {
    var color: UIColor { get }
    var delay: TimeInterval { get }

    func isEqualTo(_ other: Drawer) -> Bool
    func asEquatable() -> AnyEquatableDrawer
}

extension Drawer where Self: Equatable {
    func isEqualTo(_ other: Drawer) -> Bool {
        guard let otherX = other as? Self else { return false }
        return self == otherX
    }
    func asEquatable() -> AnyEquatableDrawer {
        return AnyEquatableDrawer(self)
    }
}

struct AnyEquatableDrawer: Drawer, Equatable {
    var color: UIColor {
        return value.color
    }
    var delay: TimeInterval {
        return value.delay
    }

    init(_ value: Drawer) { self.value = value }

    private let value: Drawer

    static func ==(lhs: AnyEquatableDrawer, rhs: AnyEquatableDrawer) -> Bool {
        return lhs.value.isEqualTo(rhs.value)
    }
}

struct Pencil: Drawer, Equatable {
    var color: UIColor
    var delay: TimeInterval
}

struct Eraser: Drawer, Equatable {
    var color: UIColor
    var delay: TimeInterval
}
