//
//  GenreViewModelTests.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 17/08/26.
//

import XCTest
import Combine

@testable import TmdbMVVM_SwiftUI

@MainActor
final class GenreViewModelTests: XCTestCase {
    
    private var sut: GenreViewModel!
    private var mockUseCase: MockGetMovieGenreUseCase!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockGetMovieGenreUseCase()
        sut = GenreViewModel(getMovieGenreUseCase: mockUseCase)
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    func test_start_success_shouldLoadGenres() {
        let expectedGenres = [
            Genre(id: 28, name: "Action"),
            Genre(id: 35, name: "Comedy")
        ]
        
        mockUseCase.result = .success(
            GenreModel(genres: expectedGenres)
        )
        
        sut.start()
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(sut.genres.count, expectedGenres.count)
        XCTAssertEqual(sut.genres.first?.name, "Action")
        XCTAssertEqual(mockUseCase.callCount, 1)
    }
    
    func test_start_failure_shouldSetErrorMessage() {
        mockUseCase.result = .failure(
            .networkError(message: "Network Error")
        )
        
        sut.start()
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.genres.isEmpty)
        XCTAssertEqual(sut.errorMessage, "Network Error")
        XCTAssertEqual(mockUseCase.callCount, 1)
    }
    
    func test_start_whenGenresAlreadyLoaded_shouldNotCallUseCaseAgain() {
        sut.genres = [
            Genre(id: 1, name: "Action")
        ]
        
        sut.start()
        
        XCTAssertEqual(mockUseCase.callCount, 0)
    }
    
    func test_start_shouldClearPreviousError() {
        sut.errorMessage = "Old Error"
        
        mockUseCase.result = .success(
            GenreModel(
                genres: [
                    Genre(id: 28, name: "Action")
                ]
            )
        )
        
        sut.start()
        
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_start_emptyGenres_shouldRemainEmpty() {
        mockUseCase.result = .success(
            GenreModel(genres: [])
        )
        
        sut.start()
        
        XCTAssertTrue(sut.genres.isEmpty)
        XCTAssertNil(sut.errorMessage)
    }
    
    //--
    
    func test_isLoading_shouldChangeFalseTrueFalse() {
        mockUseCase.result = .success(
            GenreModel(
                genres: [
                    Genre(id: 1, name: "Action")
                ]
            )
        )
        
        var loadingStates: [Bool] = []
        
        let expectation = expectation(description: "Loading state")
        
        let cancellable = sut.$isLoading
            .sink { value in
                loadingStates.append(value)
                
                if loadingStates.count == 3 {
                    expectation.fulfill()
                }
            }
        
        sut.start()
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(loadingStates, [false, true, false])
        
        cancellable.cancel()
    }
    
    func test_genresPublisher_shouldPublishGenres() {
        let expectedGenres = [
            Genre(id: 1, name: "Action"),
            Genre(id: 2, name: "Comedy")
        ]
        
        mockUseCase.result = .success(
            GenreModel(genres: expectedGenres)
        )
        
        let expectation = expectation(description: "Genres published")
        
        var received: [[Genre]] = []
        
        let cancellable = sut.$genres
            .sink { value in
                received.append(value)
                
                if value.count == 2 {
                    expectation.fulfill()
                }
            }
        
        sut.start()
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(received.last?.count, 2)
        XCTAssertEqual(received.last?.first?.name, "Action")
        
        cancellable.cancel()
    }
    
    func test_errorPublisher_shouldPublishError() {
        mockUseCase.result = .failure(
            .networkError(message: "Network Error")
        )
        
        let expectation = expectation(description: "Error published")
        
        var errors: [String?] = []
        
        let cancellable = sut.$errorMessage
            .sink { value in
                errors.append(value)
                
                if value != nil {
                    expectation.fulfill()
                }
            }
        
        sut.start()
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(errors.last, "Network Error")
        
        cancellable.cancel()
    }
    
    func test_useCase_shouldBeCalledOnce() {
        mockUseCase.result = .success(
            GenreModel(genres: [])
        )
        
        sut.start()
        
        XCTAssertEqual(mockUseCase.callCount, 1)
    }
    
    func test_start_calledTwice_shouldNotReload() {
        mockUseCase.result = .success(
            GenreModel(
                genres: [
                    Genre(id: 1, name: "Action")
                ]
            )
        )
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(mockUseCase.callCount, 1)
    }
}

// MARK: - Mock

final class MockGetMovieGenreUseCase: GetMovieGenreUseCase {
    var callCount = 0
    
    var result: Result<GenreModel, AppError> = .success(
        GenreModel()
    )
    
    func call() -> AnyPublisher<GenreModel, AppError> {
        callCount += 1
        
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
