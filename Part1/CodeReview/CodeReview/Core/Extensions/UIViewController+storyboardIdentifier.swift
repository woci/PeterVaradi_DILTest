//
//  UIViewController+storyboardIdentifier.swift
//  CodeReview
//
//  Created by Peter Varadi3 on 2023. 07. 09..
//

import Foundation
import UIKit

extension UIViewController {
    public static var storyboardIdentifier: String {
        "\(String(describing: self))StoryboardIdentifier"
    }
}
