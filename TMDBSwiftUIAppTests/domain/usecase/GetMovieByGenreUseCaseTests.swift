//
//  GetMovieByGenreUseCaseTests.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 19/08/26.
//

import XCTest
import Combine

@testable import TmdbMVVM_SwiftUI

final class GetMovieByGenreUseCaseTests: XCTestCase {
    
    private var sut: GetMovieByGenreUseCase!
    private var mockRepository: MockAppRepository!
    
    override func setUp() {
        super.setUp()
        
        mockRepository = MockAppRepository()
        sut = GetMovieByGenreUseCaseImpl(appRepository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func test_call_shouldForwardParameters() {
        let model = DiscoverMovieByGenreModel(
            page: 1,
            results: [
                Movie(id: 1, title: "Batman")
            ],
            totalPages: 10,
            totalResults: 100
        )
        
        mockRepository.movieResult = .success(model)
        
        let expectation = expectation(description: "Movies")
        
        let cancellable = sut.call(
            genreId: "28",
            page: 1
        ).sink(
            receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail(error.localizedDescription)
                }
            },
            receiveValue: { value in
                XCTAssertEqual(value.results.count, 1)
                XCTAssertEqual(value.results.first?.title, "Batman")
                
                expectation.fulfill()
            }
        )
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(mockRepository.movieCallCount, 1)
        XCTAssertEqual(mockRepository.receivedGenreId, "28")
        XCTAssertEqual(mockRepository.receivedPage, 1)
        
        cancellable.cancel()
    }
    
    func test_call_shouldForwardError() {
        mockRepository.movieResult = .failure(
            .networkError(message: "No Internet")
        )
        
        let expectation = expectation(description: "Failure")
        
        let cancellable = sut.call(
            genreId: "28",
            page: 1
        ).sink(
            receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, .networkError(message: "No Internet"))
                    
                    expectation.fulfill()
                }
            },
            receiveValue: { _ in
                XCTFail("Should not receive value")
            }
        )
        
        waitForExpectations(timeout: 1)
        
        cancellable.cancel()
    }
}
