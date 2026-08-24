//
//  TrailerResponseMapperTests.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 25/08/26.
//

import XCTest

@testable import TmdbMVVM_SwiftUI

final class TrailerResponseMapperTests: XCTestCase {

    func test_toDomain_shouldMapTrailer() {
        let dto = TrailerDto(
            key: "abc123",
            site: "YouTube",
            type: "Trailer"
        )
        
        let response = TrailerResponse(
            id: 550,
            results: [dto]
        )
        
        let model = response.toDomain()
        
        XCTAssertEqual(model.id, 550)
        XCTAssertEqual(model.results.count, 1)
        
        let trailer = model.results.first!
        
        XCTAssertEqual(trailer.key, "abc123")
        XCTAssertEqual(trailer.site, "YouTube")
    }
}
