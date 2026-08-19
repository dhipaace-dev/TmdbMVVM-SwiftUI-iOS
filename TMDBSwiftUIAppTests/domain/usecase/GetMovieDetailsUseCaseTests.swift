//
//  GetMovieDetailsUseCaseTests.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 19/08/26.
//

import XCTest
import Combine

@testable import TmdbMVVM_SwiftUI

final class GetMovieDetailsUseCaseTests: XCTestCase {
    
    private var sut: GetMovieDetailsUseCase!
    private var mockRepository: MockAppRepository!
    
    override func setUp() {
        super.setUp()
        
        mockRepository = MockAppRepository()
        sut = GetMovieDetailsUseCaseImpl(appRepository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func test_call_shouldReturnMovie() {
        let movie = MovieDetailsModel(
            id: 550,
            overview: "Overview",
            title: "Fight Club",
            imageUrl: "/fight.png"
        )
        
        mockRepository.detailResult = .success(movie)
        
        let expectation = expectation(description: "Movie")
        
        let cancellable = sut.call(movieId: 550)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { value in
                    XCTAssertEqual(value.id, 550)
                    XCTAssertEqual(value.title, "Fight Club")
                    
                    expectation.fulfill()
                }
            )
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(mockRepository.detailCallCount, 1)
        
        cancellable.cancel()
    }
    
    func test_call_shouldReturnFailure() {
        mockRepository.detailResult = .failure(
            .networkError(message: "Offline")
        )
        
        let expectation = expectation(description: "Failure")
        
        let cancellable = sut.call(movieId: 550)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertEqual(error, .networkError(message: "Offline"))
                        
                        expectation.fulfill()
                    }
                },
                receiveValue: { _ in }
            )
        
        waitForExpectations(timeout: 1)
        
        cancellable.cancel()
    }
}
