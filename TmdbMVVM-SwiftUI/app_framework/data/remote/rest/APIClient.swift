//
//  APIClient.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Alamofire
import Foundation
import Combine
import SwiftyJSON
//import data
//import domain

public class ApiClient {

    public init() {}

    func fetchMovieGenre() -> AnyPublisher<GenreResponse, NetworkError> {
        request(APIRouter.fetchMovieGenre, type: GenreResponse.self)
    }

    func fetchMovieByGenre(genreId: String, page: Int) -> AnyPublisher<DiscoverMovieByGenreResponse, NetworkError> {
        request(APIRouter.fetchMovieByGenre(genreId: genreId, page: page), type: DiscoverMovieByGenreResponse.self)
    }

    func fetchMovieDetail(movieId: Int) -> AnyPublisher<MovieDetailsResponse, NetworkError> {
        request(APIRouter.fetchMovieDetail(movieId: movieId), type: MovieDetailsResponse.self)
    }

    func fetchMovieReviews(movieId: Int, page: Int) -> AnyPublisher<ReviewResponse, NetworkError> {
        request(APIRouter.fetchMovieReviews(movieId: movieId, page: page), type: ReviewResponse.self)
    }

    func fetchMovieTrailer(movieId: Int) -> AnyPublisher<TrailerResponse, NetworkError> {
        request(APIRouter.fetchMovieTrailer(movieId: movieId), type: TrailerResponse.self)
    }

    func request<T>(_ router: APIRouter, type: T.Type) -> AnyPublisher<T, NetworkError> where T : Decodable {
        return AF.request(router)
            .publishDecodable(type: T.self)
            .tryMap { response -> T in
                guard let statusCode = response.response?.statusCode else {
                    throw NetworkError.unknown(statusCode: -1)
                }
                
                switch statusCode {
                case 200..<300:
                    if let value = response.value {
                        return value
                    } else {
                        throw NetworkError.decodingError
                    }
                case 401:
                    throw NetworkError.unauthorized
                case 403:
                    throw NetworkError.forbidden
                case 404:
                    throw NetworkError.notFound
                case 500..<600:
                    throw NetworkError.serverError
                default:
                    throw NetworkError.unknown(statusCode: statusCode)
                }
            }
            .mapError { error -> NetworkError in
                if let afError = error as? AFError {
                    return .afError(afError)
                } else if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return .unknown(statusCode: -1)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
