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

class CollectionViewAdapter: NSObject, UICollectionViewDelegate {
    enum Section {
        case main
    }
    typealias DataSource = UICollectionViewDiffableDataSource<Section, SomeModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SomeModel>

    var data: [SomeModel]
    var collectionView: UICollectionView
    weak var delegate: CollectionViewAdapterDelegate?
    private lazy var datSource = {
        DataSource(collectionView: collectionView, cellProvider: cellProvider())
    }()
    private lazy var compactLayout: UICollectionViewCompositionalLayout = {
        createLayout(numberOfItemsInARow: 1)
    }()
    private lazy var regularLayout: UICollectionViewCompositionalLayout = {
        createLayout(numberOfItemsInARow: 3)
    }()

    init(data: [SomeModel], collectionView: UICollectionView, delegate: CollectionViewAdapterDelegate?) {
        self.data = data
        self.collectionView = collectionView
        self.delegate = delegate
    }

    func configure() {
        collectionView.delegate = self
        applySnapshot()
    }

    func createLayout(numberOfItemsInARow: Int) -> UICollectionViewCompositionalLayout {
        let horizontalWidth = 1.0 / CGFloat(numberOfItemsInARow)
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(horizontalWidth),
                                                                             heightDimension: .absolute(150)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)), item: item, count: numberOfItemsInARow)
        let section = NSCollectionLayoutSection(group: group)

        return UICollectionViewCompositionalLayout(section: section)
    }

    func updateLayout(for sizeClass: UIUserInterfaceSizeClass) {
        self.collectionView.collectionViewLayout = sizeClass == .compact ? compactLayout : regularLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.clientListAdapter(self, didSelectItemAtIndex: indexPath.item)
    }

    func cellProvider() -> (UICollectionView, IndexPath, SomeModel) -> UICollectionViewCell {
        { collectionView, indexPath, model in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SomeCellType.reuseIdentifier, for: indexPath)

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
