//
//  MockAppRepository.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 18/08/26.
//

import Foundation
import Combine

@testable import TmdbMVVM_SwiftUI

final class MockAppRepository: AppRepository {
    
    // MARK: Genre
    
    var genreCallCount = 0
    
    var genreResult: Result<GenreModel, AppError> = .success(
        GenreModel(genres: [])
    )
    
    func fetchMovieGenre() -> AnyPublisher<GenreModel, AppError> {
        genreCallCount += 1
        
        switch genreResult {
        case .success(let model):
            return Just(model)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    // MARK: Movies
    
    var movieCallCount = 0
    
    var movieResult: Result<DiscoverMovieByGenreModel, AppError>!
    
    var receivedGenreId: String!
    var receivedPage: Int!
    
    func fetchMovieByGenre(genreId: String, page: Int) -> AnyPublisher<DiscoverMovieByGenreModel, AppError> {
        movieCallCount += 1
        
        receivedGenreId = genreId
        receivedPage = page
        
        switch movieResult {
        case .success(let model):
            return Just(model)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        case .none:
            fatalError()
        }
    }
    
    // MARK: Movie Details
    
    var detailCallCount = 0
    
    var detailResult: Result<MovieDetailsModel, AppError>!
    
    func fetchMovieDetail(movieId: Int) -> AnyPublisher<MovieDetailsModel, AppError> {
        detailCallCount += 1
        
        switch detailResult {
        case .success(let model):
            return Just(model)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        case .none:
            fatalError()
        }
    }
    
    // MARK: Reviews
    
    var reviewCallCount = 0
    
    var reviewResult: Result<ReviewModel, AppError>!
    
    func fetchMovieReviews(movieId: Int, page: Int) -> AnyPublisher<ReviewModel, AppError> {
        reviewCallCount += 1
        
        switch reviewResult {
        case .success(let model):
            return Just(model)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        case .none:
            fatalError()
        }
    }
    
    // MARK: Trailer
    
    var trailerCallCount = 0
    
    var trailerResult: Result<TrailerModel, AppError>!
    
    func fetchMovieTrailer(movieId: Int) -> AnyPublisher<TrailerModel, AppError> {
        trailerCallCount += 1
        
        switch trailerResult {
        case .success(let model):
            return Just(model)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        case .none:
            fatalError()
        }
    }
}
