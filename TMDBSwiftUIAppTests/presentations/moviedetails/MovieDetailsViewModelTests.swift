//
//  MovieDetailsViewModelTests.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 17/08/26.
//

import XCTest
import Combine

@testable import TmdbMVVM_SwiftUI

@MainActor
final class MovieDetailsViewModelTests: XCTestCase {
    
    private var sut: MovieDetailsViewModel!
    private var mockUseCase: MockGetMovieDetailsUseCase!
    private var cancellables: Set<AnyCancellable>!
    
    private let movieId = 550
    
    let overview = "Fight Club Overview"
    let title = "Fight Club"
    let imageUrl = "/fightclub.jpg"
    
    override func setUp() {
        super.setUp()
        
        mockUseCase = MockGetMovieDetailsUseCase()
        cancellables = []
        
        sut = MovieDetailsViewModel(
            movieId: movieId,
            getMovieDetailsUseCase: mockUseCase
        )
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_start_success_shouldLoadMovie() {
        let movie = MovieDetailsModel(
            id: movieId,
            overview: overview,
            title: title,
            imageUrl: imageUrl
        )
        
        mockUseCase.result = .success(movie)
        
        sut.start()
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        
        XCTAssertEqual(sut.movie?.id, movieId)
        XCTAssertEqual(sut.movie?.title, title)
        XCTAssertEqual(sut.movie?.overview, overview)
        XCTAssertEqual(sut.movie?.imageUrl, imageUrl)
        
        XCTAssertEqual(mockUseCase.callCount, 1)
        XCTAssertEqual(mockUseCase.receivedMovieId, movieId)
    }
    
    func test_start_failure_shouldPublishError() {
        mockUseCase.result = .failure(
            .networkError(message: "No Internet")
        )
        
        sut.start()
        
        XCTAssertNil(sut.movie)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.errorMessage, "No Internet")
        XCTAssertEqual(mockUseCase.callCount, 1)
    }
    
    func test_start_shouldNotReloadMovie() {
        let movie = MovieDetailsModel(
            id: movieId,
            overview: overview,
            title: title,
            imageUrl: imageUrl
        )
        
        mockUseCase.result = .success(movie)
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(mockUseCase.callCount, 1)
    }
    
    func test_loadingPublisher_shouldEmitFalseTrueFalse() {
        let movie = MovieDetailsModel(
            id: movieId,
            overview: overview,
            title: title,
            imageUrl: imageUrl
        )
        
        mockUseCase.result = .success(movie)
        
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
    
    func test_moviePublisher_shouldPublishMovie() {
        let expectation = expectation(description: "Movie Published")
        
        let movie = MovieDetailsModel(
            id: movieId,
            overview: overview,
            title: title,
            imageUrl: imageUrl
        )
        
        mockUseCase.result = .success(movie)
        
        sut.$movie
            .dropFirst()
            .sink { [weak self] movie in
                guard let self = self else { return }
                XCTAssertEqual(movie?.id, self.movieId)
                XCTAssertEqual(movie?.title, self.title)
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.start()
        
        waitForExpectations(timeout: 1)
    }
    
    func test_errorPublisher_shouldPublishError() {
        let expectation = expectation(description: "Error Published")
        
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

final class MockGetMovieDetailsUseCase: GetMovieDetailsUseCase {
    
    var callCount = 0
    
    var receivedMovieId: Int?
    
    var result: Result<MovieDetailsModel, AppError>!
    
    func call(movieId: Int) -> AnyPublisher<MovieDetailsModel, AppError> {
        callCount += 1
        receivedMovieId = movieId
        
        switch result {
        case .success(let movie):
            return Just(movie)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        case .none:
            fatalError("Mock result not configured.")
        }
    }
}
