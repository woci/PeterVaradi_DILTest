//
//  RendererService.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 07. 04..
//

import Foundation
import UIKit

protocol RendererService: Injectable {
    var canvas: UIView { get set }
    func render(scheduledPoint: ScheduledPoint)
}
