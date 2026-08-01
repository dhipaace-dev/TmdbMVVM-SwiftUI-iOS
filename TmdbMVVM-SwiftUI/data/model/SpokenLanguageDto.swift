//
//  SpokenLanguageDto.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation

struct SpokenLanguageDto: Codable {
    let iso6391: String?
    let name: String?
    let englishName: String?

    init(
        iso6391: String?,
        name: String?,
        englishName: String?
    ) {
        self.iso6391 = iso6391
        self.name = name
        self.englishName = englishName
    }
    
    enum CodingKeys: String, CodingKey {
        case iso6391 = "iso_639_1"
        case name
        case englishName = "english_name"
    }
}
