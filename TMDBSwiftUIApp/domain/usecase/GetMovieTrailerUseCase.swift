//
//  GetMovieTrailerUseCase.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation
import Combine

public protocol GetMovieTrailerUseCase {
    func call(movieId: Int) -> AnyPublisher<TrailerModel, AppError>
}
