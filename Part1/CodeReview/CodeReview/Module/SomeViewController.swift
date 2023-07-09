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
    //TODO: Please remove this IBOutlet dont you're not using it
//    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    //TODO: It's a better practice to show the details on a separate VC to avoid too crowded VC
//    @IBOutlet var detailViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var collectionView: UICollectionView!
    var presenter: PresenterInput!
    private var collectionViewAdapter: CollectionViewAdapter?
//    @IBOutlet var detailView: UIView!
//    var detailVC : UIViewController?
//    var dataArray : [Any]?

    override func viewWillAppear(_ animated: Bool) {
        //TODO: move to a class where business logic is
//        fetchData()
        //TODO: move to CollectionViewAdapter:
//        self.collectionView.dataSource = self
        //TODO: move to CollectionViewAdapter:
//        self.collectionView.delegate = self
        //TODO: move to CollectionViewAdapter:
//        self.collectionView.register(UINib(nibName: "someCell", bundle: nil), forCellWithReuseIdentifier: "someCell")

        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title:NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(dissmissController))
    }

    @objc func dissmissController () {}

    //TODO: move to a class where business logic is
//    func fetchData() {
//        let url = URL(string: "testreq")!
//        let task = URLSession.shared.dataTask(with: url) { [self](data, response, error) in
//            self.dataArray = data as? [Any]
//            self.collectionView.reloadData()
//        }
//        task.resume()
//    }

    //TODO: Please use the built in push/pop mechanism of a NavigationController
//    @IBAction func closeshowDetails () {
//        self.detailViewWidthConstraint.constant = 0
//        UIView.animate(withDuration: 0.5, animations:
//                        {
//            self.view.layoutIfNeeded()
//        })
//        { (completed) in
//            self.detailVC?.removeFromParent()
//        }
//    }

    //TODO: Please use the built in push/pop mechanism of a NavigationController
//    @IBAction func showDetail () {
//        self.detailViewWidthConstraint.constant = 100
//        UIView.animate(withDuration: 0.5, animations:
//                        {
//            self.view.layoutIfNeeded()
//        })
//        { (completed) in
//            self.view.addSubview(self.detailView)
//        }
//    }

    //TODO: move to CollectionViewAdapter, because it makes the collectionView reusable and makes someVC more clear
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.dataArray?.count ?? 0
//    }
    //TODO: move to CollectionViewAdapter, because it makes the collectionView reusable and makes someVC more clear
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
//    UICollectionViewCell {
//        return UICollectionViewCell()
//    }
    //TODO: move to CollectionViewAdapter, because it makes the collectionView reusable and makes someVC more clear
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.showDetail()
//    }
    //TODO: move to CollectionViewAdapter, because it makes the collectionView reusable and makes someVC more clear
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var widthMultiplier: CGFloat = 0.2929
//        if isIPhone() {
//            widthMultiplier = 0.9
//        }
//        return CGSize(width: view.frame.width * widthMultiplier ,
//                      height: 150.0)
//    }
    //TODO: move to CollectionViewAdapter, because it makes the collectionView reusable and makes someVC more clear
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//
//        let frameWidth = (view.frame.width * 0.2929 * 3) + 84
//        var minSpacing: CGFloat = (view.frame.width - frameWidth)/2
//        if isIPhone() {
//            minSpacing = 24
//        }
//        return minSpacing
//    }

    static func create() -> SomeViewController? {
        let someStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let someViewController = someStoryBoard.instantiateViewController(identifier: "SomeVCStoryboardIdentifier") as? SomeViewController else {
            return Optional.none
        }

        someViewController.presenter = Presenter(view: someViewController, service: DataFetcher(session: Session(urlSession: URLSession.shared)), data: [])

        return someViewController
    }
}

extension SomeViewController: SomeView {
    func show(result: [SomeModel]) {
        if collectionViewAdapter == nil {
            collectionViewAdapter = CollectionViewAdapter(data: [], collectionView: collectionView, delegate: self, flowLayoutConfiguration: VerticalFlowLayoutConfigurationForiPad(collectionViewWidth: collectionView.bounds.width))
        }
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

