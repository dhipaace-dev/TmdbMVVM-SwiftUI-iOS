//
//  ProductionCountryDto.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation

struct ProductionCountryDto: Codable {
    let iso31661: String?
    let name: String?

    init(
        iso31661: String?,
        name: String?
    ) {
        self.iso31661 = iso31661
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case name
    }
}
