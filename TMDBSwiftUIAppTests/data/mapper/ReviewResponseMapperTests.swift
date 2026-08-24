//
//  ReviewResponseMapperTests.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 25/08/26.
//

import XCTest

@testable import TmdbMVVM_SwiftUI

final class ReviewResponseMapperTests: XCTestCase {
    
    func test_toDomain_shouldMapReview() {
        let dto = ReviewDto(
            author: "John",
            content: "Excellent"
        )
        
        let response = ReviewResponse(
            id: 1,
            page: 1,
            results: [dto],
            totalPages: 1,
            totalResults: 1
        )
        
        let model = response.toDomain()
        
        XCTAssertEqual(model.results.count, 1)
        
        let review = model.results.first!
        
        XCTAssertEqual(review.author, "John")
        XCTAssertEqual(review.content, "Excellent")
    }
}
