//
//  GenreViewModel.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation
import Combine

@MainActor
final class GenreViewModel: ObservableObject {
    @Published var genres: [Genre] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let getMovieGenreUseCase: GetMovieGenreUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    init(getMovieGenreUseCase: GetMovieGenreUseCase) {
        self.getMovieGenreUseCase = getMovieGenreUseCase
    }
    
    func start() {
        if (!genres.isEmpty) {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        getMovieGenreUseCase.call()
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.genres = response.genres
            }
            .store(in: &cancellables)
    }
}
