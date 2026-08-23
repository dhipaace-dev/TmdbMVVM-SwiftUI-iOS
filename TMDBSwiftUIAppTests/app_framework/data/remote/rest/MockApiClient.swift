//
//  MockApiClient.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 23/08/26.
//

import Foundation
import Combine

@testable import TmdbMVVM_SwiftUI

final class MockApiClient: ApiClient {
    
    // MARK: - Call Count
    
    var genreCallCount = 0
    var movieCallCount = 0
    var detailCallCount = 0
    var reviewCallCount = 0
    var trailerCallCount = 0
    
    // MARK: - Received Parameters
    
    var receivedGenreId: String?
    var receivedPage: Int?
    var receivedMovieId: Int?
    
    // MARK: - Results
    
    var genreResult: Result<GenreResponse, NetworkError>!
    var movieResult: Result<DiscoverMovieByGenreResponse, NetworkError>!
    var detailResult: Result<MovieDetailsResponse, NetworkError>!
    var reviewResult: Result<ReviewResponse, NetworkError>!
    var trailerResult: Result<TrailerResponse, NetworkError>!
    
    // MARK: - Genre
    
    override func fetchMovieGenre() -> AnyPublisher<GenreResponse, NetworkError> {
        genreCallCount += 1
        
        guard let genreResult else {
            fatalError("Configure genreResult before calling fetchMovieGenre().")
        }
        
        return publisher(for: genreResult)
    }
    
    // MARK: Movies
    
    override func fetchMovieByGenre(genreId: String, page: Int) -> AnyPublisher<DiscoverMovieByGenreResponse, NetworkError> {
        movieCallCount += 1
        
        receivedGenreId = genreId
        receivedPage = page
        
        guard let movieResult else {
            fatalError("Configure movieResult before calling fetchMovieByGenre().")
        }
        
        return publisher(for: movieResult)
    }
    
    // MARK: Details
    
    override func fetchMovieDetail(movieId: Int) -> AnyPublisher<MovieDetailsResponse, NetworkError> {
        detailCallCount += 1
        
        receivedMovieId = movieId
        
        guard let detailResult else {
            fatalError("Configure detailResult before calling fetchMovieDetail().")
        }
        
        return publisher(for: detailResult)
    }
    
    // MARK: Reviews
    
    override func fetchMovieReviews(movieId: Int, page: Int) -> AnyPublisher<ReviewResponse, NetworkError> {
        reviewCallCount += 1
        
        receivedMovieId = movieId
        receivedPage = page
        
        guard let reviewResult else {
            fatalError("Configure reviewResult before calling fetchMovieReviews().")
        }
        
        return publisher(for: reviewResult)
    }
    
    // MARK: Trailer
    
    override func fetchMovieTrailer(movieId: Int) -> AnyPublisher<TrailerResponse, NetworkError> {
        trailerCallCount += 1
        
        receivedMovieId = movieId
        
        guard let trailerResult else {
            fatalError("Configure trailerResult before calling fetchMovieTrailer().")
        }
        
        return publisher(for: trailerResult)
    }
    
    private func publisher<T>(for result: Result<T, NetworkError>) -> AnyPublisher<T, NetworkError> {
        switch result {
        case .success(let value):
            return Just(value)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
            
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}
