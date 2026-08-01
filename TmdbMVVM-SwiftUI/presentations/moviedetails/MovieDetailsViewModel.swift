//
//  MovieDetailsViewModel.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation
import Combine

@MainActor
final class MovieDetailsViewModel: ObservableObject {
    @Published var movie: MovieDetailsModel? = nil
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let getMovieDetailsUseCase: GetMovieDetailsUseCase
    
    private let movieId: Int
    
    private var cancellables = Set<AnyCancellable>()
    
    init(movieId: Int, getMovieDetailsUseCase: GetMovieDetailsUseCase) {
        self.movieId = movieId
        self.getMovieDetailsUseCase = getMovieDetailsUseCase
    }
    
    func start() {
        if (movie != nil) {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        getMovieDetailsUseCase.call(movieId: movieId)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.movie = response
            }
            .store(in: &cancellables)
    }
}
