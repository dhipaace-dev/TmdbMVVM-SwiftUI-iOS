//
//  GetMovieGenreUseCaseTests.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 19/08/26.
//

import XCTest
import Combine

@testable import TmdbMVVM_SwiftUI

final class GetMovieGenreUseCaseTests: XCTestCase {
    
    private var sut: GetMovieGenreUseCase!
    private var mockRepository: MockAppRepository!
    
    override func setUp() {
        super.setUp()
        
        mockRepository = MockAppRepository()
        sut = GetMovieGenreUseCaseImpl(appRepository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        
        super.tearDown()
    }
    
    func test_call_shouldReturnGenres() {
        let expectedGenres = [
            Genre(id: 28, name: "Action"),
            Genre(id: 35, name: "Comedy")
        ]
        
        mockRepository.genreResult = .success(
            GenreModel(genres: expectedGenres)
        )
        
        let expectation = expectation(description: "Genre")
        
        var received: GenreModel?
        
        let cancellable = sut.call()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail(error.localizedDescription)
                    }
                }, receiveValue: { model in
                    received = model
                    expectation.fulfill()
                }
            )
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(mockRepository.genreCallCount, 1)
        XCTAssertEqual(received?.genres.count, 2)
        XCTAssertEqual(received?.genres.first?.name, "Action")
        
        cancellable.cancel()
    }
    
    func test_call_shouldForwardError() {
        mockRepository.genreResult = .failure(
            .networkError(message: "No Internet")
        )
        
        let expectation = expectation(description: "Error")
        
        var receivedError: AppError?
        
        let cancallable = sut.call()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                        expectation.fulfill()
                    }
                },
                receiveValue: { _ in
                    XCTFail("Should not receive value")
                }
            )
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(receivedError, .networkError(message: "No Internet"))
        XCTAssertEqual(mockRepository.genreCallCount, 1)
        
        cancallable.cancel()
    }
}
