//
//  SomeModel.swift
//  CodeReview
//
//  Created by Peter Varadi3 on 2023. 07. 09..
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
