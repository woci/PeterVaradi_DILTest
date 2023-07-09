//
//  Service.swift
//  CodeReview
//
//  Created by Peter Varadi3 on 2023. 07. 06..
//

import Foundation

struct DataFetcher: DataService {
    var session: HTTPClient

    func fetchData() async -> Result<[SomeModel], RequestError> {
        let request = DataRequest()
        return await session.sendRequest(endpoint: request)
    }
}

struct DataRequest: Endpoint {
    var path: String = "/userProfile"
    var method: RequestMethod = .get
    var header: [String : String]?
    var body: Codable?
}
