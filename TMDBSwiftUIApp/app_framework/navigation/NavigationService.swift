//
//  NavigationService.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation
import SwiftUI

final class NavigationService: ObservableObject {
    @Published var path = NavigationPath()
    
    private func push(_ screen: AppScreen) {
        path.append(screen)
    }
    
    func pop() {
        path.removeLast()
    }

    func navigateToMovieByGenre(genreId: Int, genreName: String) {
        push(.moviesByGenre(genreId))
    }

    func navigateToMovieDetail(movieId: Int) {
        push(.movieDetails(movieId))
    }

    func navigateToMovieReview(movieId: Int, movieTitle: String) {
        push(.movieReviews(movieId))
    }

    func navigateToMovieTrailer(movieId: Int) {
        push(.movieTrailer(movieId))
    }
}
