//
//  URLSessionService.swift
//  Supercharge
//
//  Created by Peter Varadi3 on 2023. 07. 06..
//

import Foundation

protocol URLSessionService {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}
