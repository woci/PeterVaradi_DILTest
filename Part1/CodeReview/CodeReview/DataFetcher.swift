//
//  Service.swift
//  CodeReview
//
//  Created by Peter Varadi3 on 2023. 07. 06..
//

import Foundation

struct SomeModel: Decodable, Hashable {
    let id: String
    let prop1: String
    let prop2: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

protocol DataService {
    func fetchData() async -> Result<[SomeModel], RequestError>
}

struct DataFetcher: DataService {
    var session: HTTPClient

    func fetchData() async -> Result<[SomeModel], RequestError> {
        let request = DataRequest()
        return await session.sendRequest(endpoint: request)
    }
}
