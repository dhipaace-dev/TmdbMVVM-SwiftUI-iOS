//
//  GetMovieByGenreUseCaseImpl.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation
import Combine

public struct GetMovieByGenreUseCaseImpl: GetMovieByGenreUseCase {

    let appRepository: AppRepository

    public init(appRepository: AppRepository) {
        self.appRepository = appRepository
    }

    public func call(genreId: String, page: Int) -> AnyPublisher<DiscoverMovieByGenreModel, AppError> {
        return appRepository.fetchMovieByGenre(genreId: genreId, page: page)
    }
}
