//
//  ImageFullVersion.swift
//  macpaw-cat-app
//
//  Created by Kadir Kadyrov on 17.05.2020.
//  Copyright © 2020 Kadir Kadyrov. All rights reserved.
//

import Foundation
import UIKit
struct ImageFullVersion: Codable {
    let id,
        url: String
    let category: Categories?
    var breeds: Breeds?
    let width: Int
    let height: Int
}


typealias Images = [ImageFullVersion]
