//
//  GetMovieDetailsUseCaseImpl.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation
import Combine

public struct GetMovieDetailsUseCaseImpl: GetMovieDetailsUseCase {

    let appRepository: AppRepository

    public init(appRepository: AppRepository) {
        self.appRepository = appRepository
    }

    public func call(movieId: Int) -> AnyPublisher<MovieDetailsModel, AppError> {
        return appRepository.fetchMovieDetail(movieId: movieId)
    }
}
