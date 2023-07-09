//
//  UICollectionViewCell+storyboardIdentifier.swift
//  CodeReview
//
//  Created by Peter Varadi3 on 2023. 07. 09..
//

import Foundation
import UIKit

extension UICollectionViewCell {
    public static var reuseIdentifier: String {
        "\(String(describing: self))ReuseIdentifier"
    }
}
