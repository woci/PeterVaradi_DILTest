//
//  CollectionViewAdapter.swift
//  CodeReview
//
//  Created by Peter Varadi3 on 2023. 07. 06..
//

import Foundation
import UIKit

protocol CollectionViewAdapterDelegate: AnyObject {
    func clientListAdapter(_ collectionViewAdapter: CollectionViewAdapter, didSelectItemAtIndex index: Int)
}

class CollectionViewAdapter: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    enum Section {
        case main
    }
    var data: [SomeModel]
    var collectionView: UICollectionView
    weak var delegate: CollectionViewAdapterDelegate?
    typealias DataSource = UICollectionViewDiffableDataSource<Section, SomeModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SomeModel>
    private lazy var datSource = {
        DataSource(collectionView: collectionView, cellProvider: cellProvider())
    }()
    private var flowLayoutConfiguration: LayoutConfiguration

    init(data: [SomeModel], collectionView: UICollectionView, delegate: CollectionViewAdapterDelegate?, flowLayoutConfiguration: LayoutConfiguration) {
        self.data = data
        self.collectionView = collectionView
        self.delegate = delegate
        self.flowLayoutConfiguration = flowLayoutConfiguration
    }

    func configure() {
        collectionView.delegate = self

        applySnapshot()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: due to the extraction, you have to create a delegate call
//        self.showDetail()
        self.delegate?.clientListAdapter(self, didSelectItemAtIndex: indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //TODO: Please don't use magic numbers, instead try to do it a cleaner way with meaningful variable names, functions and make it flexible
        CGSize(width: flowLayoutConfiguration.widthForItem(), height: flowLayoutConfiguration.heightForItem)
//        var widthMultiplier: CGFloat = 0.2929
//        if isIPhone() {
//            widthMultiplier = 0.9
//        }
//        return CGSize(width: view.frame.width * widthMultiplier ,
//                      height: 150.0)
    }

    func isIPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    func itemsPerRow() -> Int {
        isIPhone() ? 1 : 3
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        let frameWidth = (view.frame.width * 0.2929 * 3) + 84
        var minSpacing: CGFloat = (view.frame.width - frameWidth)/2
        if isIPhone() {
            minSpacing = 24
        }
        return minSpacing
    }

    func cellProvider() -> (UICollectionView, IndexPath, SomeModel) -> UICollectionViewCell {
        { collectionView, indexPath, model in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SomeCell", for: indexPath)

            guard let cell = cell as? SomeCellType else {
                return cell
            }

            cell.setup()
        }
    }

    func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)

        datSource.apply(snapshot, animatingDifferences: true)
    }
}

class SomeCellType: UICollectionViewCell {
    func setup() {}
}

struct VerticalFlowLayoutConfiguration: LayoutConfiguration {
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
