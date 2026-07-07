//
//  GenreViewModel.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation

@MainActor
final class GenreViewModel: ObservableObject {
    @Published var genres: [Genre] = []
    
    func loadGenres() async {
        do {
            let response: GenreResponse = try await TMDBClient.fetch("/genre/movie/list?language=en-US")
            genres = response.genres
        } catch {
            print(error)
        }
    }
}
