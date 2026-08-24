//
//  GenreResponseMapperTests.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 25/08/26.
//

import XCTest

@testable import TmdbMVVM_SwiftUI

final class GenreResponseMapperTests: XCTestCase {
    
    func test_toDomain_shouldMapGenres() {
        let response = GenreResponse(
            genres: [
                GenreDto(id: 28, name: "Action"),
                GenreDto(id: 35, name: "Comedy")
            ]
        )
        
        let model = response.toDomain()
        
        XCTAssertEqual(model.genres.count, 2)
        
        XCTAssertEqual(model.genres[0].id, 28)
        XCTAssertEqual(model.genres[0].name, "Action")
        
        XCTAssertEqual(model.genres[1].id, 35)
        XCTAssertEqual(model.genres[1].name, "Comedy")
    }
    
    func test_toDomain_whenEmptyGenres_shouldReturnEmptyArray() {
        let response = GenreResponse(genres: [])
        let model = response.toDomain()
        
        XCTAssertTrue(model.genres.isEmpty)
    }
}
