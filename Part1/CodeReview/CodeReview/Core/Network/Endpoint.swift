//
//  Endpoint.swift
//  Supercharge
//
//  Created by Peter Varadi3 on 2023. 07. 06..
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: Codable? { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "api.example.com"
    }
}
