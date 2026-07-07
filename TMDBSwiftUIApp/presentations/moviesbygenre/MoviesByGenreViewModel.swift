//
//  MoviesByGenreViewModel.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation

@MainActor
final class MoviesByGenreViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    let genreID: Int
    
    init(genreID: Int) {
        self.genreID = genreID
    }
    
    func loadMovies() async {
        do {
            let response: MovieResponse = try await TMDBClient.fetch("/discover/movie?with_genres=\(genreID)")
            movies = response.results
        } catch {
            print(error)
        }
    }
}
