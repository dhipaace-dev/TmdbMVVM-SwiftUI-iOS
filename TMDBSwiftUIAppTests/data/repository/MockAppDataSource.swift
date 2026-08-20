//
//  MockAppDataSource.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 20/08/26.
//

import Foundation
import Combine

@testable import TmdbMVVM_SwiftUI

final class MockAppDataSource: AppDataSource {
    
    // MARK: Genre
    
    var genreCallCount = 0
    var genreResult: Result<GenreResponse, AppError>!
    
    // MARK: Movies
    
    var movieCallCount = 0
    var receivedGenreId: String?
    var receivedPage: Int?
    var movieResult: Result<DiscoverMovieByGenreResponse, AppError>!
    
    // MARK: Details
    
    var detailCallCount = 0
    var detailResult: Result<MovieDetailsResponse, AppError>!
    
    // MARK: Reviews
    
    var reviewCallCount = 0
    var reviewResult: Result<ReviewResponse, AppError>!
    
    // MARK: Trailer
    
    var trailerCallCount = 0
    var trailerResult: Result<TrailerResponse, AppError>!
    
    func fetchMovieGenre() -> AnyPublisher<GenreResponse, AppError> {
        genreCallCount += 1
        
        switch genreResult {
        case .success(let response):
            return Just(response)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
            
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
            
        case .none:
            fatalError("Configure genreResult")
        }
    }
    
    func fetchMovieByGenre(genreId: String, page: Int) -> AnyPublisher<DiscoverMovieByGenreResponse, AppError> {
        movieCallCount += 1
        
        switch movieResult {
        case .success(let response):
            return Just(response)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
            
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
            
        case .none:
            fatalError("Configure movieResult")
        }
    }
    
    func fetchMovieDetail(movieId: Int) -> AnyPublisher<MovieDetailsResponse, AppError> {
        detailCallCount += 1
        
        switch detailResult {
        case .success(let response):
            return Just(response)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
            
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
            
        case .none:
            fatalError("Configure detailResult")
        }
    }
    
    func fetchMovieReviews(movieId: Int, page: Int) -> AnyPublisher<ReviewResponse, AppError> {
        reviewCallCount += 1
        
        switch reviewResult {
        case .success(let response):
            return Just(response)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
            
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
            
        case .none:
            fatalError("Configure reviewResult")
        }
    }
    
    func fetchMovieTrailer(movieId: Int) -> AnyPublisher<TrailerResponse, AppError> {
        trailerCallCount += 1
        
        switch trailerResult {
        case .success(let response):
            return Just(response)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
            
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
            
        case .none:
            fatalError("Configure trailerResult")
        }
    }
}
