//
//  MovieDetailsResponseMapperTests.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 25/08/26.
//

import XCTest

@testable import TmdbMVVM_SwiftUI

final class MovieDetailsResponseMapperTests: XCTestCase {
    
    func test_toDomain_shouldMapMovieDetails() {
        let response = MovieDetailsResponse(
            genres: [
                GenreDto(id: 28, name: "Action")
            ],
            id: 550,
            overview: "Overview",
            runtime: 120,
            title: "Batman"
        )
        
        let movie = response.toDomain()
        
        XCTAssertEqual(movie.id, 550)
        XCTAssertEqual(movie.title, "Batman")
        XCTAssertEqual(movie.overview, "Overview")
    }
}
