//
//  GetMovieReviewUseCase.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation
import Combine

public protocol GetMovieReviewUseCase {
    func call(movieId: Int, page: Int) -> AnyPublisher<ReviewModel, AppError>
}
