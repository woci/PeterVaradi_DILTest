//
//  Drawing.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 06. 29..
//

import Foundation

struct Drawing: Equatable {
    static func == (lhs: Drawing, rhs: Drawing) -> Bool {
        lhs.points == rhs.points
        && lhs.pencil.asEquatable() == rhs.pencil.asEquatable()
    }
    var points: [Point]
    var pencil: any Drawer
}
