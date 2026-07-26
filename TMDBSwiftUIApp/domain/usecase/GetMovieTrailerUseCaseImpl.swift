//
//  GetMovieTrailerUseCaseImpl.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation
import Combine

public struct GetMovieTrailerUseCaseImpl: GetMovieTrailerUseCase {

    let appRepository: AppRepository

    public init(appRepository: AppRepository) {
        self.appRepository = appRepository
    }

    public func call(movieId: Int) -> AnyPublisher<TrailerModel, AppError> {
        return appRepository.fetchMovieTrailer(movieId: movieId)
    }
}
