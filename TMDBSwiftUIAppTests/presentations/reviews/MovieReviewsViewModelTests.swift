//
//  MovieReviewsViewModelTests.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 17/08/26.
//

import XCTest
import Combine

@testable import TmdbMVVM_SwiftUI

@MainActor
final class MovieReviewsViewModelTests: XCTestCase {
    
    private var sut: MovieReviewsViewModel!
    private var mockUseCase: MockGetMovieReviewUseCase!
    private var cancellables: Set<AnyCancellable>!
    
    private let movieId = 102
    
    override func setUp() {
        super.setUp()
        
        mockUseCase = MockGetMovieReviewUseCase()
        cancellables = []
        
        sut = MovieReviewsViewModel(
            movieId: movieId,
            getMovieReviewUseCase: mockUseCase
        )
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_start_success_shouldLoadReviews() {
        let reviews = [
            Review(id: "1", author: "John", content: "Excellent movie!"),
            Review(id: "2", author: "Jane", content: "Amazing!")
        ]
        
        mockUseCase.result = .success(
            ReviewModel(
                results: reviews
            )
        )
        
        sut.start()
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        
        XCTAssertEqual(sut.reviews.count, reviews.count)
        XCTAssertEqual(sut.reviews.first?.author, "John")
        
        XCTAssertEqual(mockUseCase.callCount, 1)
        XCTAssertEqual(mockUseCase.receivedMovieId, movieId)
        XCTAssertEqual(mockUseCase.receivedPage, 1)
    }
    
    func test_start_failure_shouldPublishError() {
        mockUseCase.result = .failure(
            .networkError(message: "No Internet!")
        )
        
        sut.start()
        
        XCTAssertTrue(sut.reviews.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.errorMessage, "No Internet!")
    }
    
    func test_start_shouldNotReloadWhenAlreadyLoaded() {
        sut.reviews = [
            Review(id: "1", author: "John", content: "Review")
        ]
        
        sut.start()
        
        XCTAssertEqual(mockUseCase.callCount, 0)
    }
    
    func test_loadMore_shouldLoadSecondPage() {
        mockUseCase.result = .success(
            ReviewModel(
                results: [
                    Review(id: "1", author: "John", content: "Review")
                ]
            )
        )
        
        sut.start()
        
        mockUseCase.result = .success(
            ReviewModel(
                results: [
                    Review(id: "2", author: "Jane", content: "Another Review")
                ]
            )
        )
        
        sut.loadMoreReviewsIfNeeded(currentReview: sut.reviews.last!)
        
        XCTAssertEqual(mockUseCase.callCount, 2)
        XCTAssertEqual(mockUseCase.receivedPage, 2)
        XCTAssertEqual(sut.reviews.count, 2)
    }
    
    func test_loadMore_whenNotLastReview_shouldDoNothing() {
        sut.reviews = [
            Review(id: "1", author: "A", content: ""),
            Review(id: "2", author: "B", content: "")
        ]
        
        sut.loadMoreReviewsIfNeeded(currentReview: sut.reviews.first!)
        
        XCTAssertEqual(mockUseCase.callCount, 0)
    }
    
    func test_loadingPublisher() {
        mockUseCase.result = .success(
            ReviewModel(
                results: []
            )
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
    
    func test_reviewsPublisher() {
        let expectation = expectation(description: "Reviews")
        
        mockUseCase.result = .success(
            ReviewModel(
                results: [
                    Review(id: "1", author: "John", content: "Review")
                ]
            )
        )
        
        sut.$reviews
            .dropFirst()
            .sink { value in
                XCTAssertEqual(value.count, 1)
                XCTAssertEqual(value.first!.author, "John")
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.start()
        
        waitForExpectations(timeout: 1)
    }
}

final class MockGetMovieReviewUseCase: GetMovieReviewUseCase {
    
    var callCount = 0
    
    var receivedMovieId: Int?
    var receivedPage: Int?
    
    var result: Result<ReviewModel, AppError>!
    
    func call(movieId: Int, page: Int) -> AnyPublisher<ReviewModel, AppError> {
        callCount += 1
        receivedMovieId = movieId
        receivedPage = page
        
        switch result {
        case .success(let model):
            return Just(model)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        case .none:
            fatalError("Configure result first.")
        }
    }
}
