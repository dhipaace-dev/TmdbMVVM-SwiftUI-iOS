//
//  MovieTrailerViewModelTests.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 17/08/26.
//

import XCTest
import Combine

@testable import TmdbMVVM_SwiftUI

@MainActor
final class MovieTrailerViewModelTests: XCTestCase {
    
    private var sut: MovieTrailerViewModel!
    private var mockUseCase: MockGetMovieTrailerUseCase!
    private var cancellables: Set<AnyCancellable>!
    
    private let movieId = 105
    
    override func setUp() {
        super.setUp()
        
        mockUseCase = MockGetMovieTrailerUseCase()
        cancellables = []
        
        sut = MovieTrailerViewModel(
            movieId: movieId,
            getMovieTrailerUseCase: mockUseCase
        )
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        cancellables = nil
        
        super.tearDown()
    }
    
    func test_start_success_shouldLoadYoutubeTrailer() {
        mockUseCase.result = .success(
            TrailerModel(
                id: 120,
                results: [
                    Trailer(key: "abc123", site: "YouTube")
                ]
            )
        )
        
        sut.start()
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(sut.movieKey, "abc123")
        
        XCTAssertEqual(mockUseCase.callCount, 1)
        XCTAssertEqual(mockUseCase.receivedMovieId, movieId)
    }
    
    func test_start_failure_shouldPublishError() {
        mockUseCase.result = .failure(
            .networkError(message: "No Internet")
        )
        
        sut.start()
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.errorMessage, "No Internet")
        XCTAssertNil(sut.movieKey)
    }
    
    func test_start_shouldIgnoreNonYoutubeTrailer() {
        mockUseCase.result = .success(
            TrailerModel(
                id: 120,
                results: [
                    Trailer(key: "vimeo_key", site: "Vimeo")
                ]
            )
        )
        
        sut.start()
        
        XCTAssertNil(sut.movieKey)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_start_shouldSelectFirstYoutubeTrailer() {
        mockUseCase.result = .success(
            TrailerModel(
                id: 120,
                results: [
                    Trailer(key: "vimeo_key", site: "Vimeo"),
                    Trailer(key: "youtube1", site: "YouTube"),
                    Trailer(key: "youtube2", site: "YouTube")
                ]
            )
        )
        
        sut.start()
        
        XCTAssertEqual(sut.movieKey, "youtube1")
    }
    
    func test_start_shouldNotReloadWhenMovieKeyAlreadyExixts() {
        sut.movieKey = "existing"
        
        sut.start()
        
        XCTAssertEqual(mockUseCase.callCount, 0)
    }
    
    func test_loadingPublisher_shouldEmitFalseTrueFalse() {
        mockUseCase.result = .success(
            TrailerModel(id: 120, results: [])
        )
        
        let expectation = expectation(description: "Loading")
        
        var values: [Bool] = []
        
        sut.$isLoading
            .sink { value in
                values.append(value)
                
                if values.count == 3 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.start()
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(values, [false, true, false])
    }
    
    func test_movieKeyPublisher_shouldPublishYoutubeKey() {
        let expectation = expectation(description: "Movie Key")
        
        mockUseCase.result = .success(
            TrailerModel(
                id: 120,
                results: [
                    Trailer(key: "abc123", site: "YouTube")
                ]
            )
        )
        
        sut.$movieKey
            .dropFirst()
            .sink { key in
                XCTAssertEqual(key, "abc123")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.start()
        
        waitForExpectations(timeout: 1)
    }
    
    func test_errorPublisher_shouldPublishError() {
        let expectation = expectation(description: "Error")
        
        mockUseCase.result = .failure(
            .networkError(message: "No Internet")
        )
        
        sut.$errorMessage
            //.dropFirst()
            .compactMap { $0 }
            .prefix(1)
            .sink { error in
                XCTAssertEqual(error, "No Internet")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.start()
        
        waitForExpectations(timeout: 1)
    }
}

final class MockGetMovieTrailerUseCase: GetMovieTrailerUseCase {
    
    var callCount = 0
    var receivedMovieId: Int?
    
    var result: Result<TrailerModel, AppError>!
    
    func call(movieId: Int) -> AnyPublisher<TrailerModel, AppError> {
        callCount += 1
        receivedMovieId = movieId
        
        switch result {
        case .success(let model):
            return Just(model)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
            
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
            
        case .none:
            fatalError("Configure result before calling")
        }
    }
}
