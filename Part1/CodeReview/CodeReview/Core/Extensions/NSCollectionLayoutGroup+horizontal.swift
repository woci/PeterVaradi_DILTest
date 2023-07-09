//
//  NS+horizontal.swift
//  CodeReview
//
//  Created by Peter Varadi3 on 2023. 07. 09..
//

import Foundation
import UIKit

extension NSCollectionLayoutGroup {
    static func horizontal(layoutSize: NSCollectionLayoutSize, item: NSCollectionLayoutItem, count: Int) -> NSCollectionLayoutGroup {
        if #available(iOS 16.0, *) {
            return NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, repeatingSubitem: item, count: count)
        } else {
            return NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: count)
        }
    }
}
