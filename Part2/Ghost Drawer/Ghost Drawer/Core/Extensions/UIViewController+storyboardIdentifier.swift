//
//  UIViewController+storyboardIdentifier.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 07. 05..
//

import Foundation
import UIKit

extension UIViewController {
    static var storyBoardIdentifier: String {
        String(describing: self) + "StoryboardIdentifer"
    }
}
