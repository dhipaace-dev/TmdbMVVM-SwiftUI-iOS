//
//  GetMovieByGenreUseCase.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation
import Combine

public protocol GetMovieByGenreUseCase {
    func call(genreId: String, page: Int) -> AnyPublisher<DiscoverMovieByGenreModel, AppError>
}

