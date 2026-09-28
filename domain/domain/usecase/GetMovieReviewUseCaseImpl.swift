//
//  GetMovieReviewUseCaseImpl.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation
import Combine

public struct GetMovieReviewUseCaseImpl: GetMovieReviewUseCase {

    let appRepository: AppRepository

    public init(appRepository: AppRepository) {
        self.appRepository = appRepository
    }

    public func call(movieId: Int, page: Int) -> AnyPublisher<ReviewModel, AppError> {
        return appRepository.fetchMovieReviews(movieId: movieId, page: page)
    }
}
