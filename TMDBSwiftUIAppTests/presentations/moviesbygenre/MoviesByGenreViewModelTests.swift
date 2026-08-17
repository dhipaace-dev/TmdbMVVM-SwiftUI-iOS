//
//  MoviesByGenreViewModelTests.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 17/08/26.
//

import XCTest
import Foundation
import Combine

@testable import TmdbMVVM_SwiftUI

@MainActor
final class MoviesByGenreViewModelTests: XCTestCase {
    
    private var sut: MoviesByGenreViewModel!
    private var mockUseCase: MockGetMovieByGenreUseCase!
    
    private var genreId = 101
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockGetMovieByGenreUseCase()
        sut = MoviesByGenreViewModel(genreId: genreId, getMovieByGenreUseCase: mockUseCase)
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    func test_start_shouldLoadFirstPage() {
        let movies = [
            Movie(id: 1, title: "Batman"),
            Movie(id: 2, title: "Superman")
        ]
        
        mockUseCase.result = .success(
            DiscoverMovieByGenreModel(
                page: 1,
                results: movies,
                totalPages: 10,
                totalResults: 20
            )
        )
        
        sut.start()
        
        XCTAssertEqual(sut.movies.count, 2)
        XCTAssertEqual(mockUseCase.callCount, 1)
        XCTAssertEqual(mockUseCase.receivedPage, 1)
    }
    
    func test_start_whenMoviesAlreadyExist_shouldNotReload() {
        sut.movies = [
            Movie(id: 1, title: "Batman")
        ]
        
        sut.start()
        
        XCTAssertEqual(mockUseCase.callCount, 0)
    }
    
    func test_start_failure_shouldSetError() {
        mockUseCase.result = .failure(
            .networkError(message: "No Internet")
        )
        
        sut.start()
        
        XCTAssertTrue(sut.movies.isEmpty)
        XCTAssertEqual(sut.errorMessage, "No Internet")
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_start_emptyMovies_shouldRemainEmpty() {
        mockUseCase.result = .success(
            DiscoverMovieByGenreModel(
                page: 1,
                results: [],
                totalPages: 1,
                totalResults: 0
            )
        )
        
        sut.start()
        
        XCTAssertTrue(sut.movies.isEmpty)
    }
    
    func test_shouldPassGenreId() {
        sut.start()
        
        XCTAssertEqual(Int(mockUseCase.receivedGenreId ?? "0"), genreId)
    }
    
    func test_shouldRequestPageOneInitially() {
        sut.start()
        
        XCTAssertEqual(mockUseCase.receivedPage, 1)
    }
    
    func test_loadMore_shouldRequestSecondPage() {
        mockUseCase.result = .success(
            DiscoverMovieByGenreModel(
                page: 1,
                results: [
                    Movie(id: 1, title: "batman")
                ],
                totalPages: 2,
                totalResults: 2
            )
        )
        
        sut.start()
        
        mockUseCase.result = .success(
            DiscoverMovieByGenreModel(
                page: 2,
                results: [
                    Movie(id: 2, title: "Superman")
                ],
                totalPages: 2,
                totalResults: 2
            )
        )
        
        sut.loadMoreMoviesIfNeeded(currentMovie: sut.movies.last!)
        
        XCTAssertEqual(mockUseCase.callCount, 2)
        XCTAssertEqual(mockUseCase.receivedPage, 2)
        XCTAssertEqual(sut.movies.count, 2)
    }
    
    func test_loadMore_whenNotLastMovie_shouldNotFetch() {
        sut.movies = [
            Movie(id: 1, title: "Batman"),
            Movie(id: 2, title: "Superman")
        ]
        
        sut.loadMoreMoviesIfNeeded(currentMovie: sut.movies.first!)
        
        XCTAssertEqual(mockUseCase.callCount, 0)
    }
    
    func test_loadMore_whenEmptyMovies_shouldDoNothing() {
        sut.loadMoreMoviesIfNeeded(currentMovie: Movie(id: 1, title: "Batman"))
        
        XCTAssertEqual(mockUseCase.callCount, 0)
    }
    
    func test_loadMore_shouldAppendMovies() {
        mockUseCase.result = .success(
            DiscoverMovieByGenreModel(
                page: 1,
                results: [
                    Movie(id: 1, title: "A")
                ],
                totalPages: 2,
                totalResults: 2
            )
        )
        
        sut.start()
        
        mockUseCase.result = .success(
            DiscoverMovieByGenreModel(
                page: 2,
                results: [
                    Movie(id: 2, title: "B")
                ],
                totalPages: 2,
                totalResults: 2
            )
        )
        
        sut.loadMoreMoviesIfNeeded(currentMovie: sut.movies.last!)
        
        XCTAssertEqual(sut.movies.map(\.id), [1, 2])
    }
}

final class MockGetMovieByGenreUseCase: GetMovieByGenreUseCase {
    
    var callCount = 0
    
    var result: Result<DiscoverMovieByGenreModel, AppError> = .success(
        DiscoverMovieByGenreModel(page: 1, results: [], totalPages: 1, totalResults: 0)
    )
    
    var receivedGenreId: String?
    var receivedPage: Int?
    
    func call(genreId: String, page: Int) -> AnyPublisher<DiscoverMovieByGenreModel, AppError> {
        callCount += 1
        
        receivedGenreId = genreId
        receivedPage = page
        
        switch result {
        case .success(let model):
            return Just(model)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}
