//
//  v.swift
//  CodeReview
//
//  Created by Peter Varadi3 on 2023. 07. 09..
//

import Foundation
import UIKit

struct VerticalFlowLayoutConfigurationForiPhone: LayoutConfiguration {
    var collectionViewWidth: CGFloat
    var itemsPerRow: Int = 3
    var padding: CGFloat = 12.0
    var sidePadding: CGFloat {
        itemSpacing * 1.5
    }
    var itemSpacing: CGFloat {
        return padding / 2
    }
    var insetForSectionAt: UIEdgeInsets {
        return UIEdgeInsets(top: sidePadding, left: 0, bottom: sidePadding, right: 0)
    }

    var heightForItem: CGFloat = 150

    func widthForItem() -> CGFloat {
        let allItemSpacing = CGFloat(itemsPerRow - 1) * itemSpacing
        let itemWidth = (collectionViewWidth - 2 * sidePadding - allItemSpacing) / CGFloat(itemsPerRow)
        return itemWidth
    }
}
