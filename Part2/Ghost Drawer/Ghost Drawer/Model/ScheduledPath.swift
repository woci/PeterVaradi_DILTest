//
//  ScheduledPath.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 07. 04..
//

import Foundation
import UIKit

struct ScheduledPath: Equatable {
    var from: CGPoint
    var to: CGPoint
    var color: UIColor
    var renderInterval: TimeInterval
}
