//
//  Presenter.swift
//  CodeReview
//
//  Created by Peter Varadi3 on 2023. 07. 06..
//

import Foundation

protocol SomePresenterInput {
    func fetchData()
    func showDetails(atIndex index: Int)
}

class SomePresenter: SomePresenterInput {
    weak var view: SomeView?
    var service: DataService
    var data: [SomeModel]

    init(view: SomeView?, service: DataService, data: [SomeModel]) {
        self.view = view
        self.service = service
        self.data = data
    }

    func fetchData() {
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
