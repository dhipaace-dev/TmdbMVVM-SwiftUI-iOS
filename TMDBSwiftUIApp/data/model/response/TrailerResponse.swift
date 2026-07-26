//
//  TrailerResponse.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation
//import domain

public struct TrailerResponse: Decodable {
    let id: Int?
    let results: [TrailerDto]?

    init(
        id: Int?,
        results: [TrailerDto]?
    ) {
        self.id = id
        self.results = results
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case results
    }
}

extension TrailerResponse {
    func toDomain() -> TrailerModel {
        let trailerEntities = results?.map { (trailer) -> Trailer in
            return Trailer(
                id: trailer.id ?? "",
                key: trailer.key ?? "",
                name: trailer.name ?? "",
                site: trailer.site ?? ""
            )
        }

        return TrailerModel(id: self.id ?? -1, results: trailerEntities ?? [])
    }
}
