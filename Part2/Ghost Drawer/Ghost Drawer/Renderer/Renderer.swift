//
//  Renderer.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 06. 29..
//

import Foundation
import UIKit

class Renderer {
    var canvas: UIView

    init(canvas: UIView) {
        self.canvas = canvas
        canvas.backgroundColor = .cyan
    }

    func render(scheduledPoint: ScheduledPoint) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineCap = .round
        shapeLayer.lineWidth = 20
        shapeLayer.strokeColor = scheduledPoint.color.cgColor

        let path = UIBezierPath()
        path.move(to: scheduledPoint.from)
        path.addLine(to: scheduledPoint.to)
        shapeLayer.path = path.cgPath

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = scheduledPoint.renderInterval
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.isRemovedOnCompletion = false
        animation.fillMode = .both
        animation.isAdditive = false

        shapeLayer.add(animation, forKey: "fadeIn")
        self.canvas.layer.addSublayer(shapeLayer)
    }

//    func render(scheduledPoint: ScheduledPoint) {
//        let path = UIBezierPath()
//        path.move(to: scheduledPoint.from)
//        path.addLine(to: scheduledPoint.to)
//
//
//        let animation = CABasicAnimation(keyPath: "opacity")
//        animation.duration = scheduledPoint.renderInterval
//        animation.fromValue = 0.0
//        animation.toValue = 1.0
//        animation.isRemovedOnCompletion = false
//        animation.fillMode = .both
//        animation.isAdditive = false
//
//        if scheduledPoint.color == .white {
//
//            let eraserLayer = CAShapeLayer()
//            eraserLayer.lineCap = .round
//            eraserLayer.lineWidth = 20
//            eraserLayer.strokeColor = UIColor.black.cgColor
//
//            if self.canvas.layer.mask == nil {
//                self.canvas.layer.mask = eraserLayer
//            } else {
//                eraserLayer.path = path.cgPath
//                eraserLayer.add(animation, forKey: "fadeIn")
//
//                (self.canvas.layer.mask as? CAShapeLayer)?.mask?.mask = eraserLayer
//
//                self.canvas.layer.mask = self.canvas.layer.mask?.flatten()
//            }
//            //            self.canvas.layer.mask = eraserLayer
////
////            // Create new path and mask
////            let newMask = CAShapeLayer()
////            newMask.lineCap = .round
////            newMask.lineWidth = 20
////            newMask.strokeColor = UIColor.white.cgColor
////            let newPath = path
////
////            // Create path to clip
////            let newClipPath = UIBezierPath(rect: canvas.bounds)
////            newClipPath.append(newPath)
////
////            // If view already has a mask
////            if let originalMask = canvas.layer.mask,
////               let originalShape = originalMask as? CAShapeLayer,
////               let originalPath = originalShape.path {
////
////                // Create bezierpath from original mask's path
////                let originalBezierPath = UIBezierPath(cgPath: originalPath)
////
////                // Append view's bounds to "reset" the mask path before we re-apply the original
////                newClipPath.append(UIBezierPath(rect: canvas.bounds))
////
////                // Combine new and original paths
////                newClipPath.append(originalBezierPath)
////
////            }
////
////            // Apply new mask
////            newMask.path = newClipPath.cgPath
//////            newMask.fillRule = .evenOdd
////            newMask.add(animation, forKey: "fadeIn")
//////            newMask.compositingFilter = "xor"
//////            canvas.layer.mask = newMask
////
////            // Create a large opaque layer to serve as the inverted mask
////            let largeOpaqueLayer = CALayer()
//////            largeOpaqueLayer.bounds = canvas.bounds
////            largeOpaqueLayer.bounds = CGRect(x: -10_000_000, y: -10_000_000, width: 20_000_000, height: 20_000_000)
////            largeOpaqueLayer.backgroundColor = UIColor.black.cgColor
////
////            // Subtract out the mask shape using the `xor` blend mode
////            largeOpaqueLayer.addSublayer(newMask)
////            newMask.compositingFilter = "xor"
////            canvas.layer.mask = largeOpaqueLayer
////            // Subtract out the mask shape using the `xor` blend mode
//        } else {
//
//            let shapeLayer = CAShapeLayer()
//            shapeLayer.lineCap = .round
//            shapeLayer.lineWidth = 20
//            shapeLayer.strokeColor = scheduledPoint.color.cgColor
//
//
//            shapeLayer.path = path.cgPath
//
//            shapeLayer.add(animation, forKey: "fadeIn")
//            self.canvas.layer.addSublayer(shapeLayer)
//        }
//
//    }
}
