//
//  AppRepositoryImpl.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation
import Combine
//import domain

public class AppRepositoryImpl: AppRepository {

    let appDataSource: AppDataSource

    init(appDataSource: AppDataSource) {
        self.appDataSource = appDataSource
    }

    public func fetchMovieGenre() -> AnyPublisher<GenreModel, AppError> {
        appDataSource.fetchMovieGenre()
            .map { response in
                response.toDomain()
            }
            .eraseToAnyPublisher()
    }

    public func fetchMovieByGenre(genreId: String, page: Int) -> AnyPublisher<DiscoverMovieByGenreModel, AppError> {
        appDataSource.fetchMovieByGenre(genreId: genreId, page: page)
            .map { (response) -> DiscoverMovieByGenreModel in
                response.toDomain()
            }
            .eraseToAnyPublisher()
    }

    public func fetchMovieDetail(movieId: Int) -> AnyPublisher<MovieDetailsModel, AppError> {
        appDataSource.fetchMovieDetail(movieId: movieId)
            .map { (response) -> MovieDetailsModel in
                response.toDomain()
            }
            .eraseToAnyPublisher()
    }

    public func fetchMovieReviews(movieId: Int, page: Int) -> AnyPublisher<ReviewModel, AppError> {
        appDataSource.fetchMovieReviews(movieId: movieId, page: page)
            .map { (response) -> ReviewModel in
                response.toDomain()
            }
            .eraseToAnyPublisher()
    }

    public func fetchMovieTrailer(movieId: Int) -> AnyPublisher<TrailerModel, AppError> {
        appDataSource.fetchMovieTrailer(movieId: movieId)
            .map { (response) -> TrailerModel in
                response.toDomain()
            }
            .eraseToAnyPublisher()
    }
}
