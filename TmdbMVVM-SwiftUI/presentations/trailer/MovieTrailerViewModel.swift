//
//  TrailerViewModel.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation
import Combine

@MainActor
final class MovieTrailerViewModel: ObservableObject {
    @Published var movieKey: String? = nil
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let getMovieTrailerUseCase: GetMovieTrailerUseCase
    
    private let movieId: Int
    
    private var cancellables = Set<AnyCancellable>()
    
    init(movieId: Int, getMovieTrailerUseCase: GetMovieTrailerUseCase) {
        self.movieId = movieId
        self.getMovieTrailerUseCase = getMovieTrailerUseCase
    }
    
    func start() {
        if (movieKey != nil) {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        getMovieTrailerUseCase.call(movieId: movieId)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                let trailers = response.results
                for trailer in trailers {
                    if trailer.site.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == "youtube" {
                        self?.movieKey = trailer.key
                        break
                    }
                }
            }
            .store(in: &cancellables)
    }
}
