//
//  Services.swift
//  CodeReview
//
//  Created by Peter Varadi3 on 2023. 07. 08..
//

import Foundation
import UIKit

protocol LayoutConfiguration {
    var collectionViewWidth: CGFloat { get set }
    var itemsPerRow: Int { get set }
    var padding: CGFloat { get set }
    var sidePadding: CGFloat { get }
    var itemSpacing: CGFloat { get }
    var insetForSectionAt: UIEdgeInsets { get }
    var heightForItem: CGFloat { get set }
    func widthForItem() -> CGFloat
}
