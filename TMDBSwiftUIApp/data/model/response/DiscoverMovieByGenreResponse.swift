//
//  DiscoverMovieByGenreResponse.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation
//import domain

public struct DiscoverMovieByGenreResponse: Decodable {
    let page: Int?
    let results: [MovieDto]?
    let totalPages: Int?
    let totalResults: Int?

    init(
        page: Int?,
        results: [MovieDto]?,
        totalPages: Int?,
        totalResults: Int?
    ) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

extension DiscoverMovieByGenreResponse {
    func toDomain() -> DiscoverMovieByGenreModel {
        let movieEntities = results?.map { (movie) -> Movie in
            return Movie(
                id: movie.id ?? -1,
                title: movie.title ?? "",
                overview: movie.overview ?? "",
                imageUrl: (!(movie.posterPath?.isEmpty ?? true)) ? DataConstants.IMAGE_URL_BASE_PATH + (movie.posterPath ?? "") : ""
            )
        }

        return DiscoverMovieByGenreModel(
            page: self.page ?? -1,
            results: movieEntities ?? [],
            totalPages: self.totalPages ?? -1,
            totalResults: self.totalResults ?? -1
        )
    }
}
