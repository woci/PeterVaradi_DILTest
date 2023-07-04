//
//  Injectable.swift
//  Ghost Drawer
//
//  Created by Peter Varadi3 on 2023. 07. 04..
//

import Foundation

protocol Injectable {
    static var registeredName: String { get }
}

extension Injectable {
    static var registeredName: String {
        String(describing: self)
    }
}
