//
//  GenreResponse.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation
//import domain

public struct GenreResponse: Decodable {
    let genres: [GenreDto]?

    init(genres: [GenreDto]?) {
        self.genres = genres
    }
    
    enum CodingKeys: String, CodingKey {
        case genres
    }
}

extension GenreResponse {
    func toDomain() -> GenreModel {
        let genreEntities = genres?.map { (genre) -> Genre in
            return Genre(id: genre.id ?? -1, name: genre.name ?? "")
        }

        return GenreModel(genres: genreEntities ?? [])
    }
}
