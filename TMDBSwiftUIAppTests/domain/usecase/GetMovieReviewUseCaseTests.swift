//
//  GetMovieReviewUseCaseTests.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 19/08/26.
//

import XCTest
import Combine

@testable import TmdbMVVM_SwiftUI

final class GetMovieReviewUseCaseTests: XCTestCase {
    
    private var sut: GetMovieReviewUseCase!
    private var mockRepository: MockAppRepository!
    
    override func setUp() {
        super.setUp()
        
        mockRepository = MockAppRepository()
        sut = GetMovieReviewUseCaseImpl(appRepository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func test_call_shouldReturnReviews() {
        let expectation = expectation(description: "Reviews")
        
        mockRepository.reviewResult = .success(
            ReviewModel(
                results: [
                    Review(id: "1", author: "John", content: "Great")
                ]
            )
        )
        
        let cancellable = sut.call(movieId: 550, page: 1)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { value in
                    XCTAssertEqual(value.results.count, 1)
                    XCTAssertEqual(value.results.first?.author, "John")
                    
                    expectation.fulfill()
                }
            )
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(mockRepository.reviewCallCount, 1)
        
        cancellable.cancel()
    }
}
