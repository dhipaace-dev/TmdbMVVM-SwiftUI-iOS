//
//  RemoteDataSourceImpl.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation
import Combine
//import domain
//import data

public class RemoteDataSourceImpl: AppDataSource {

    let apiClient: ApiClient

    public init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }

    public func fetchMovieGenre() -> AnyPublisher<GenreResponse, AppError> {
        apiClient.fetchMovieGenre()
            .mapError { error in
                AppError.networkError(message: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }

    public func fetchMovieByGenre(genreId: String, page: Int) -> AnyPublisher<DiscoverMovieByGenreResponse, AppError> {
        apiClient.fetchMovieByGenre(genreId: genreId, page: page)
            .mapError { error in
                AppError.networkError(message: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }

    public func fetchMovieDetail(movieId: Int) -> AnyPublisher<MovieDetailsResponse, AppError> {
        apiClient.fetchMovieDetail(movieId: movieId)
            .mapError { error in
                AppError.networkError(message: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }

    public func fetchMovieReviews(movieId: Int, page: Int) -> AnyPublisher<ReviewResponse, AppError> {
        apiClient.fetchMovieReviews(movieId: movieId, page: page)
            .mapError { error in
                AppError.networkError(message: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }

    public func fetchMovieTrailer(movieId: Int) -> AnyPublisher<TrailerResponse, AppError> {
        apiClient.fetchMovieTrailer(movieId: movieId)
            .mapError { error in
                AppError.networkError(message: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
