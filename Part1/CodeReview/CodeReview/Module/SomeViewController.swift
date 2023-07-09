//
//  SomeVC.swift
//  CodeReview
//
//  Created by Peter Varadi3 on 2023. 07. 06..
//

import Foundation
import UIKit

protocol SomeView: AnyObject {
    func show(result: [SomeModel])
    func openDetails(with: SomeModel)
}
class SomeViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    var presenter: SomePresenterInput!
    private var collectionViewAdapter: CollectionViewAdapter?

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title:NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(dissmissController))
    }

    @objc func dissmissController () {}

    static func create() -> SomeViewController? {
        let someStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let someViewController = someStoryBoard.instantiateViewController(identifier: SomeViewController.storyboardIdentifier) as? SomeViewController else {
            return Optional.none
        }

        someViewController.presenter = SomePresenter(view: someViewController, service: DataFetcher(session: Session(urlSession: URLSession.shared)), data: [])

        return someViewController
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        collectionViewAdapter?.updateLayout(for: traitCollection.horizontalSizeClass)
    }
}

extension SomeViewController: SomeView {
    func show(result: [SomeModel]) {
        if collectionViewAdapter == nil {
            collectionViewAdapter = CollectionViewAdapter(data: [], collectionView: collectionView, delegate: self)
        }
        collectionViewAdapter?.updateLayout(for: traitCollection.horizontalSizeClass)
        collectionViewAdapter?.data = result
    }

    func openDetails(with: SomeModel) {
        //TODO: create the detailsViewController and push to the navigationController
    }
}

extension SomeViewController: CollectionViewAdapterDelegate {
    func clientListAdapter(_ collectionViewAdapter: CollectionViewAdapter, didSelectItemAtIndex index: Int) {
        presenter.showDetails(atIndex: index)
    }
}

