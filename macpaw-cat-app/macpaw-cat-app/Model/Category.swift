//
//  Categories.swift
//  macpaw-cat-app
//
//  Created by Kadir Kadyrov on 17.05.2020.
//  Copyright © 2020 Kadir Kadyrov. All rights reserved.
//

import Foundation

struct Category: Codable {
    let id: Int
    let name: String
}

typealias Categories = [Category]
