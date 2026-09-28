//
//  Genre.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation

struct GenreDto: Identifiable, Decodable {
    let id: Int?
    let name: String?
    
    init(id: Int? = nil, name: String? = nil) {
        self.id = id
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
