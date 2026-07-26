//
//  MoviesByGenreViewModel.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation
import Combine

@MainActor
final class MoviesByGenreViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let getMovieByGenreUseCase: GetMovieByGenreUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    private var page = 0
    private let genreId: Int
    
    init(genreId: Int, getMovieByGenreUseCase: GetMovieByGenreUseCase) {
        self.genreId = genreId
        self.getMovieByGenreUseCase = getMovieByGenreUseCase
    }
    
    func start() {
        if (!movies.isEmpty) {
            return
        }
        
        fetchMoviesGenre()
    }
    
    private func fetchMoviesGenre() {
        isLoading = true
        errorMessage = nil
        
        let page = self.page + 1
        
        getMovieByGenreUseCase.call(genreId: "\(genreId)", page: page)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                let movies = response.results
                if movies.count > 0 {
                    for movie in movies {
                        self?.movies.append(movie)
                    }

                    self?.page = page
                }
            }
            .store(in: &cancellables)
    }
    
    func loadMoreMoviesIfNeeded(currentMovie: Movie) {
        guard let last = movies.last else { return }
        if (currentMovie.id == last.id) {
            fetchMoviesGenre()
        }
    }
}
