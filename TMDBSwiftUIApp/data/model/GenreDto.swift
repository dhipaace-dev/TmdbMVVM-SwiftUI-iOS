//
//  Genre.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation

struct GenreDto: Identifiable, Decodable {
    let id: Int?
    let name: String?
    
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
