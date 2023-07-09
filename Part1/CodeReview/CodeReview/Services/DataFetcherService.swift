//
//  DataFetcherService.swift
//  CodeReview
//
//  Created by Peter Varadi3 on 2023. 07. 09..
//

import Foundation

protocol DataService {
    func fetchData() async -> Result<[SomeModel], RequestError>
}
