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

//TODO: You don't have to conform to UICollectionViewDelegate if you use UICollectionViewDelegateFlowLayout, because delegate is inherited from the layout delegate.
class CollectionViewAdapter: NSObject, UICollectionViewDelegate {
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

    init(data: [SomeModel], collectionView: UICollectionView, delegate: CollectionViewAdapterDelegate?) {
        self.data = data
        self.collectionView = collectionView
        self.delegate = delegate
    }

    func configure() {
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
        applySnapshot()
    }

    func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(isIPhone() ? 1.0 : 1.0/3.0), heightDimension: .absolute(150)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)), item: item, count: self.isIPhone() ? 1 : 3)
        let section = NSCollectionLayoutSection(group: group)

        return UICollectionViewCompositionalLayout(section: section)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: due to the extraction, you have to create a delegate call
//        self.showDetail()
        self.delegate?.clientListAdapter(self, didSelectItemAtIndex: indexPath.item)
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //TODO: Please don't use magic numbers, instead try to do it a cleaner way with meaningful variable names, functions and make it flexible or a more easier solution is using CompositionalLayout
//        var widthMultiplier: CGFloat = 0.2929
//        if isIPhone() {
//            widthMultiplier = 0.9
//        }
//        return CGSize(width: view.frame.width * widthMultiplier ,
//                      height: 150.0)
//    }

    func isIPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

//    func itemsPerRow() -> Int {
//        isIPhone() ? 1 : 3
//    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//
//        let frameWidth = (view.frame.width * 0.2929 * 3) + 84
//        var minSpacing: CGFloat = (view.frame.width - frameWidth)/2
//        if isIPhone() {
//            minSpacing = 24
//        }
//        return minSpacing
//    }

    func cellProvider() -> (UICollectionView, IndexPath, SomeModel) -> UICollectionViewCell {
        { collectionView, indexPath, model in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SomeCell", for: indexPath)

            guard let cell = cell as? SomeCellType else {
                return cell
            }

            cell.setup()

            return cell
        }
    }

    func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)

        datSource.apply(snapshot, animatingDifferences: true)
    }
}

extension NSCollectionLayoutGroup {
    static func horizontal(layoutSize: NSCollectionLayoutSize, item: NSCollectionLayoutItem, count: Int) -> NSCollectionLayoutGroup {
        if #available(iOS 16.0, *) {
            return NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, repeatingSubitem: item, count: 3)
        } else {
            return NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: count)
        }
    }
}
