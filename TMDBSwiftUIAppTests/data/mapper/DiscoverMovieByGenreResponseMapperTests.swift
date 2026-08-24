//
//  DiscoverMovieByGenreResponseMapperTests.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 25/08/26.
//

import XCTest

@testable import TmdbMVVM_SwiftUI

final class DiscoverMovieByGenreResponseMapperTests: XCTestCase {
    
    func test_toDomain_shouldMapMovie() {
        let dto = MovieDto(
            id: 100,
            overview: "Overview",
            releaseDate: "2024-01-01",
            title: "Batman",
            voteAverage: 8.5
        )
        
        let response = DiscoverMovieByGenreResponse(
            page: 1,
            results: [dto],
            totalPages: 10,
            totalResults: 100
        )
        
        let model = response.toDomain()
        
        XCTAssertEqual(model.page, 1)
        XCTAssertEqual(model.totalPages, 10)
        XCTAssertEqual(model.totalResults, 100)
        
        XCTAssertEqual(model.results.count, 1)
        
        let movie = model.results.first!
        
        XCTAssertEqual(movie.id, 100)
        XCTAssertEqual(movie.title, "Batman")
        XCTAssertEqual(movie.overview, "Overview")
    }
    
    func test_toDomain_shouldCreateImageUrl() {
        let dto = MovieDto(
            id: 1,
            posterPath: "/poster.jpg",
            title: "Movie"
        )
        
        let response = DiscoverMovieByGenreResponse(
            page: 1,
            results: [dto],
            totalPages: 1,
            totalResults: 1
        )
        
        let movie = response.toDomain().results.first!
        
        XCTAssertTrue(movie.imageUrl.contains("/poster.jpg"))
    }
}
