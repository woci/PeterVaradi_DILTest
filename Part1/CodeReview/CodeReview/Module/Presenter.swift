//
//  Presenter.swift
//  CodeReview
//
//  Created by Peter Varadi3 on 2023. 07. 06..
//

import Foundation

protocol PresenterInput {
    func fetchData()
    func showDetails(atIndex index: Int)
}

class Presenter: PresenterInput {
    weak var view: SomeView?
    var service: DataService
    var data: [SomeModel]

    init(view: SomeView?, service: DataService, data: [SomeModel]) {
        self.view = view
        self.service = service
        self.data = data
    }

    func fetchData() {
        //TODO: Please create a networking layer for fetching data, use async/await or a background dispatchqueue
//        let url = URL(string: "testreq")!
//        let task = URLSession.shared.dataTask(with: url) { [self](data, response, error) in
//            self.dataArray = data as? [Any]
//            self.collectionView.reloadData()
//        }
//        task.resume()
        Task {
            let result = await service.fetchData()
            switch result {
            case .success(let data):
                self.data = data
                view?.show(result: data)
            case .failure(let error):
                //TODO: handle the error
                print("At least one executable statement")
            }
        }
    }

    func showDetails(atIndex index: Int) {
        self.view?.openDetails(with: data[index])
    }
}
