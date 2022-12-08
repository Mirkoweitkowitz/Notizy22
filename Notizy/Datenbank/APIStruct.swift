//
//  APIStruct.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 07.12.22.
//

import Foundation

// MARK: - APIElement

struct APIElement: Codable {
    let name: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case name
        case imageURL = "imageUrl"
    }
}

typealias ApiStart = [APIElement]
