//
//  ReviewsViewModel.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation
import Combine

@MainActor
final class MovieReviewsViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let getMovieReviewUseCase: GetMovieReviewUseCase
    
    private var page = 0
    private let movieId: Int
    
    private var cancellables = Set<AnyCancellable>()
    
    init(movieId: Int, getMovieReviewUseCase: GetMovieReviewUseCase) {
        self.movieId = movieId
        self.getMovieReviewUseCase = getMovieReviewUseCase
    }
    
    func start() {
        if (!reviews.isEmpty) {
            return
        }
        
        fetchMovieReviews()
    }
    
    func fetchMovieReviews() {
        isLoading = true
        errorMessage = nil
        
        let page = self.page + 1
        
        getMovieReviewUseCase.call(movieId: movieId, page: page)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                let reviews = response.results
                if reviews.count > 0 {
                    for review in reviews {
                        self?.reviews.append(review)
                    }

                    self?.page = page
                }
            }
            .store(in: &cancellables)
    }
    
    func loadMoreReviewsIfNeeded(currentReview: Review) {
        guard let last = reviews.last else { return }
        if (currentReview.id == last.id) {
            fetchMovieReviews()
        }
    }
}
