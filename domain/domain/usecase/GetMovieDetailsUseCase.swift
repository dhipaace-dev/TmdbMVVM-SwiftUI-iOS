//
//  GetMovieDetailsUseCase.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation
import Combine

public protocol GetMovieDetailsUseCase {
    func call(movieId: Int) -> AnyPublisher<MovieDetailsModel, AppError>
}
