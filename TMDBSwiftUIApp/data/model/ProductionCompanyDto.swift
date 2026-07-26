//
//  ProductionCompanyDto.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation

struct ProductionCompanyDto: Codable {
    let name: String?
    let originCountry: String?
    let logoPath: String?
    let id: Int?

    init(
        name: String?,
        originCountry: String?,
        logoPath: String?,
        id: Int?
    ) {
        self.name = name
        self.originCountry = originCountry
        self.logoPath = logoPath
        self.id = id
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case originCountry = "origin_country"
        case logoPath = "logo_path"
        case id
    }
}
