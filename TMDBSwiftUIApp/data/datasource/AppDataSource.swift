//
//  AppDataSource.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation
import Combine

protocol AppDataSource {
    func fetchMovieGenre() -> AnyPublisher<GenreResponse, AppError>
    func fetchMovieByGenre(genreId: String, page: Int) -> AnyPublisher<DiscoverMovieByGenreResponse, AppError>
    func fetchMovieDetail(movieId: Int) -> AnyPublisher<MovieDetailsResponse, AppError>
    func fetchMovieReviews(movieId: Int, page: Int) -> AnyPublisher<ReviewResponse, AppError>
    func fetchMovieTrailer(movieId: Int) -> AnyPublisher<TrailerResponse, AppError>
}
