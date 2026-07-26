//
//  AppRepository.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation
import Combine

public protocol AppRepository {
    func fetchMovieGenre() -> AnyPublisher<GenreModel, AppError>
    func fetchMovieByGenre(genreId: String, page: Int) -> AnyPublisher<DiscoverMovieByGenreModel, AppError>
    func fetchMovieDetail(movieId: Int) -> AnyPublisher<MovieDetailsModel, AppError>
    func fetchMovieReviews(movieId: Int, page: Int) -> AnyPublisher<ReviewModel, AppError>
    func fetchMovieTrailer(movieId: Int) -> AnyPublisher<TrailerModel, AppError>
}
