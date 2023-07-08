//
//  File.swift
//  Supercharge
//
//  Created by Peter Varadi3 on 2023. 07. 06..
//

import Foundation

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: any Endpoint) async -> Result<T, RequestError>
    var urlSession: URLSessionService { get set }
}

extension HTTPClient {
    func sendRequest<T: Decodable>(
        endpoint: any Endpoint
    ) async -> Result<T, RequestError> {
        //TODO: elaborate it
    }
}
