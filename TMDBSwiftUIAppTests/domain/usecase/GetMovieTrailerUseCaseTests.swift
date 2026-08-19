//
//  GetMovieTrailerUseCaseTests.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 19/08/26.
//

import XCTest
import Combine

@testable import TmdbMVVM_SwiftUI

final class GetMovieTrailerUseCaseTests: XCTestCase {
    
    private var sut: GetMovieTrailerUseCase!
    private var mockRepository: MockAppRepository!
    
    override func setUp() {
        super.setUp()
        
        mockRepository = MockAppRepository()
        sut = GetMovieTrailerUseCaseImpl(appRepository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func test_call_shouldReturnTrailer() {
        let expectation = expectation(description: "Trailer")
        
        mockRepository.trailerResult = .success(
            TrailerModel(
                id: 550,
                results: [
                    Trailer(
                        key: "abc123",
                        site: "YouTube"
                    )
                ]
            )
        )
        
        let cancellable = sut.call(movieId: 550)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { value in
                    XCTAssertEqual(value.results.first?.key, "abc123")
                    
                    expectation.fulfill()
                }
            )
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(mockRepository.trailerCallCount, 1)
        
        cancellable.cancel()
    }
}
