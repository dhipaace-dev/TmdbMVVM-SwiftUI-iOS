//
//  AppRepositoryImplTests.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 21/08/26.
//

import XCTest
import Combine

@testable import TmdbMVVM_SwiftUI

final class AppRepositoryImplTests: XCTestCase {
    
    private var sut: AppRepository!
    private var mockDataSource: MockAppDataSource!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        mockDataSource = MockAppDataSource()
        cancellables = []
        sut = AppRepositoryImpl(appDataSource: mockDataSource)
    }
    
    override func tearDown() {
        sut = nil
        mockDataSource = nil
        cancellables = nil
        
        super.tearDown()
    }
    
    func test_fetchMovieGenre_success() {
        let expectation = expectation(description: "Genre")
        
        mockDataSource.genreResult = .success(
            GenreResponse(
                genres: [
                    GenreDto(id: 28, name: "Action")
                ]
            )
        )
        
        sut.fetchMovieGenre()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail(error.localizedDescription)
                    }
                }, receiveValue: { value in
                    XCTAssertEqual(value.genres.count, 1)
                    XCTAssertEqual(value.genres.first?.id, 28)
                    XCTAssertEqual(value.genres.first?.name, "Action")
                    
                    expectation.fulfill()
                }).store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(mockDataSource.genreCallCount, 1)
    }
    
    func test_fetchMovieGenre_failure() {
        let expectation = expectation(description: "Failure")
        
        let error = AppError.networkError(message: "Offline")
     
        mockDataSource.genreResult = .failure(error)
        
        sut.fetchMovieGenre()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let received) = completion {
                        XCTAssertEqual(received, error)
                        
                        expectation.fulfill()
                    }
                }, receiveValue: { _ in
                    XCTFail()
                }).store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func test_fetchMovieByGenre_success() {
        let expectation = expectation(description: "Movies")
        
        mockDataSource.movieResult = .success(
            DiscoverMovieByGenreResponse(
                page: 2,
                results: [
                    MovieDto(id: 100, overview: "Overview", posterPath: "/.poster.jpg", title: "Batman")
                ],
                totalPages: 5,
                totalResults: 50
            )
        )
        
        sut.fetchMovieByGenre(genreId: "28", page: 2)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { value in
                    XCTAssertEqual(value.page, 2)
                    XCTAssertEqual(value.results.count, 1)
                    XCTAssertEqual(value.results.first?.title, "Batman")
                    
                    XCTAssertTrue(value.results.first?.imageUrl.contains("/.poster.jpg") ?? false)
                    
                    expectation.fulfill()
                }).store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(mockDataSource.movieCallCount, 1)
        XCTAssertEqual(mockDataSource.receivedGenreId, "28")
        XCTAssertEqual(mockDataSource.receivedPage, 2)
    }
    
    func test_fetchMovieByGenre_failure() {
        let expectation = expectation(description: "Failure")
        
        let error = AppError.networkError(message: "Offline")
     
        mockDataSource.movieResult = .failure(error)
        
        sut.fetchMovieByGenre(genreId: "28", page: 2)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let received) = completion {
                        XCTAssertEqual(received, error)
                        
                        expectation.fulfill()
                    }
                }, receiveValue: { _ in
                    XCTFail()
                }).store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func test_fetchMovieDetail_success() {
        let expectation = expectation(description: "Detail")
        
        mockDataSource.detailResult = .success(
            MovieDetailsResponse(
                id: 550,
                overview: "Batman Overview",
                title: "Batman"
            )
        )
        
        sut.fetchMovieDetail(movieId: 550)
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                XCTAssertEqual(value.id, 550)
                XCTAssertEqual(value.title, "Batman")
                XCTAssertEqual(value.overview, "Batman Overview")
                
                expectation.fulfill()
            }).store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(mockDataSource.detailCallCount, 1)
    }
    
    func test_fetchMovieDetail_failure() {
        let expectation = expectation(description: "Failure")
        
        let error = AppError.networkError(message: "Offline")
     
        mockDataSource.detailResult = .failure(error)
        
        sut.fetchMovieDetail(movieId: 550)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let received) = completion {
                        XCTAssertEqual(received, error)
                        
                        expectation.fulfill()
                    }
                }, receiveValue: { _ in
                    XCTFail()
                }).store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func test_fetchMovieReviews_success() {
        let expectation = expectation(description: "Reviews")
        
        let author = AuthorDetailsDto(avatarPath: "https://image.com/avatar.jpg")
        
        mockDataSource.reviewResult = .success(
            ReviewResponse(
                id: 1,
                page: 1,
                results: [
                    ReviewDto(
                        author: "John",
                        authorDetails: author,
                        content: "Excellent",
                        id: "10"
                    )
                ],
                totalPages: 1,
                totalResults: 1
            )
        )
        
        sut.fetchMovieReviews(movieId: 550, page: 1)
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                XCTAssertEqual(value.results.count, 1)
                XCTAssertEqual(value.results.first?.author, "John")
                XCTAssertEqual(value.results.first?.content, "Excellent")
                
                expectation.fulfill()
            }).store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(mockDataSource.reviewCallCount, 1)
    }
    
    func test_fetchMovieReviews_failure() {
        let expectation = expectation(description: "Failure")
        
        let error = AppError.networkError(message: "Offline")
     
        mockDataSource.reviewResult = .failure(error)
        
        sut.fetchMovieReviews(movieId: 550, page: 1)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let received) = completion {
                        XCTAssertEqual(received, error)
                        
                        expectation.fulfill()
                    }
                }, receiveValue: { _ in
                    XCTFail()
                }).store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func test_fetchMovieTrailer_success() {
        let expectation = expectation(description: "Trailer")
        
        mockDataSource.trailerResult = .success(
            TrailerResponse(
                id: 550,
                results: [
                    TrailerDto(
                        id: "1",
                        key: "abc123",
                        name: "Official Trailer",
                        site: "YouTube"
                    )
                ]
            )
        )
        
        sut.fetchMovieTrailer(movieId: 550)
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                XCTAssertEqual(value.id, 550)
                XCTAssertEqual(value.results.count, 1)
                XCTAssertEqual(value.results.first?.key, "abc123")
                XCTAssertEqual(value.results.first?.site, "YouTube")
                
                expectation.fulfill()
            }).store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(mockDataSource.trailerCallCount, 1)
    }
    
    func test_fetchMovieTrailer_failure() {
        let expectation = expectation(description: "Failure")
        
        let error = AppError.networkError(message: "Offline")
     
        mockDataSource.trailerResult = .failure(error)
        
        sut.fetchMovieTrailer(movieId: 550)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let received) = completion {
                        XCTAssertEqual(received, error)
                        
                        expectation.fulfill()
                    }
                }, receiveValue: { _ in
                    XCTFail()
                }).store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
}
