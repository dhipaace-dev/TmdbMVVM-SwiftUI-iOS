//
//  GetMovieGenreUseCaseImpl.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation
import Combine

public struct GetMovieGenreUseCaseImpl: GetMovieGenreUseCase {

    let appRepository: AppRepository

    public init(appRepository: AppRepository) {
        self.appRepository = appRepository
    }

    public func call() -> AnyPublisher<GenreModel, AppError> {
        return appRepository.fetchMovieGenre()
    }
}
