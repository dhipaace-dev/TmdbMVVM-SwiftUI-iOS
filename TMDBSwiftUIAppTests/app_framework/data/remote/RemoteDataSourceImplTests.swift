//
//  RemoteDataSourceImplTests.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 23/08/26.
//

import XCTest
import Combine

@testable import TmdbMVVM_SwiftUI

final class RemoteDataSourceImplTests: XCTestCase {
    
    private var sut: AppDataSource!
    private var mockApiClient: MockApiClient!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        mockApiClient = MockApiClient()
        cancellables = []
        
        sut = RemoteDataSourceImpl(apiClient: mockApiClient)
    }
    
    override func tearDown() {
        sut = nil
        mockApiClient = nil
        cancellables = nil
        
        super.tearDown()
    }
    
    func test_fetchMovieGenre_success() {
        let expectation = expectation(description: "Genre")
        
        mockApiClient.genreResult = .success(
            GenreResponse(
                genres: [
                    GenreDto(id: 28, name: "Action")
                ]
            )
        )
        
        sut.fetchMovieGenre()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail(error.localizedDescription)
                }
            }, receiveValue: { response in
                XCTAssertEqual(response.genres?.count, 1)
                XCTAssertEqual(response.genres?.first?.id, 28)
                XCTAssertEqual(response.genres?.first?.name, "Action")
                
                expectation.fulfill()
            }).store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(mockApiClient.genreCallCount, 1)
    }
    
    func test_fetchMovieGenre_failure() {
        let expectation = expectation(description: "Failure")
        
        mockApiClient.genreResult = .failure(
            NetworkError.noData
        )
        
        sut.fetchMovieGenre()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertEqual(error, .networkError(message: NetworkError.noData.localizedDescription))
                        
                        expectation.fulfill()
                    }
                },
                receiveValue: { _ in
                    XCTFail()
                }
            ).store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func test_fetchMovieByGenre_success() {
        let expectation = expectation(description: "Movies")
        
        mockApiClient.movieResult = .success(
            DiscoverMovieByGenreResponse(
                page: 2,
                results: [
                    MovieDto(id: 100, title: "Batman")
                ],
                totalPages: 5,
                totalResults: 50
            )
        )
        
        sut.fetchMovieByGenre(genreId: "28", page: 2)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { response in
                    XCTAssertEqual(response.page, 2)
                    XCTAssertEqual(response.results?.count, 1)
                    
                    expectation.fulfill()
                }
            ).store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(mockApiClient.movieCallCount, 1)
        XCTAssertEqual(mockApiClient.receivedGenreId, "28")
        XCTAssertEqual(mockApiClient.receivedPage, 2)
    }
    
    func test_fetchMovieByGenre_failure() {
        let expectation = expectation(description: "Failure")
        
        mockApiClient.movieResult = .failure(
            NetworkError.noData
        )
        
        sut.fetchMovieByGenre(genreId: "28", page: 2)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertEqual(error, .networkError(message: NetworkError.noData.localizedDescription))
                        
                        expectation.fulfill()
                    }
                },
                receiveValue: { _ in
                    XCTFail()
                }
            ).store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func test_fetchMovieDetail_success() {
        let expectation = expectation(description: "Detail")
        
        mockApiClient.detailResult = .success(
            MovieDetailsResponse(
                id: 550,
                overview: "Overview",
                posterPath: "/poster.jpg",
                title: "Batman"
            )
        )
        
        sut.fetchMovieDetail(movieId: 550)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { response in
                    XCTAssertEqual(response.id, 550)
                    XCTAssertEqual(response.title, "Batman")
                    
                    expectation.fulfill()
                }
            ).store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(mockApiClient.detailCallCount, 1)
        XCTAssertEqual(mockApiClient.receivedMovieId, 550)
    }
    
    func test_fetchMovieDetail_failure() {
        let expectation = expectation(description: "Failure")
        
        mockApiClient.detailResult = .failure(
            NetworkError.noData
        )
        
        sut.fetchMovieDetail(movieId: 550)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertEqual(error, .networkError(message: NetworkError.noData.localizedDescription))
                        
                        expectation.fulfill()
                    }
                },
                receiveValue: { _ in
                    XCTFail()
                }
            ).store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func test_fetchMovieReviews_success() {
        let expectation = expectation(description: "Reviews")
        
        mockApiClient.reviewResult = .success(
            ReviewResponse(
                page: 1,
                results: [
                    ReviewDto(
                        author: "John",
                        content: "Excellent"
                    )
                ],
                totalPages: 1,
                totalResults: 1
            )
        )
        
        sut.fetchMovieReviews(movieId: 550, page: 1)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { response in
                    XCTAssertEqual(response.results?.count, 1)
                    
                    expectation.fulfill()
                }
            ).store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(mockApiClient.reviewCallCount, 1)
    }
    
    func test_fetchMovieReviews_failure() {
        let expectation = expectation(description: "Failure")
        
        mockApiClient.reviewResult = .failure(
            NetworkError.noData
        )
        
        sut.fetchMovieReviews(movieId: 550, page: 1)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertEqual(error, .networkError(message: NetworkError.noData.localizedDescription))
                        
                        expectation.fulfill()
                    }
                },
                receiveValue: { _ in
                    XCTFail()
                }
            ).store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func test_fetchMovieTrailer_success() {
        let expectation = expectation(description: "Trailer")
        
        mockApiClient.trailerResult = .success(
            TrailerResponse(
                id: 550,
                results: [
                    TrailerDto(
                        key: "abc123",
                        site: "YouTube"
                    )
                ]
            )
        )
        
        sut.fetchMovieTrailer(movieId: 550)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { response in
                    XCTAssertEqual(response.results?.first?.key, "abc123")
                    
                    expectation.fulfill()
                }
            ).store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(mockApiClient.trailerCallCount, 1)
    }
    
    func test_fetchMovieTrailer_failure() {
        let expectation = expectation(description: "Failure")
        
        mockApiClient.trailerResult = .failure(
            NetworkError.noData
        )
        
        sut.fetchMovieTrailer(movieId: 550)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTAssertEqual(error, .networkError(message: NetworkError.noData.localizedDescription))
                        
                        expectation.fulfill()
                    }
                },
                receiveValue: { _ in
                    XCTFail()
                }
            ).store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
}
