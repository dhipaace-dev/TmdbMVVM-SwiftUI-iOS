//
//  GetMovieGenreUseCase.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation
import Combine

public protocol GetMovieGenreUseCase {
    func call() -> AnyPublisher<GenreModel, AppError>
}
