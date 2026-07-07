//
//  MovieDetailsViewModel.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation

@MainActor
final class MovieDetailsViewModel: ObservableObject {
    let movieID: Int
    
    init(movieID: Int) {
        self.movieID = movieID
    }
}
