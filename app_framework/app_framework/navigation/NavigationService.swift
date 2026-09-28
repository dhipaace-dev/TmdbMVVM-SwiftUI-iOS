//
//  NavigationService.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation
import SwiftUI

public final class NavigationService: ObservableObject {
    @Published public var path = NavigationPath()
    
    public init() {}
    
    private func push(_ screen: AppScreen) {
        path.append(screen)
    }
    
    public func pop() {
        path.removeLast()
    }

    public func navigateToMovieByGenre(genreId: Int, genreName: String) {
        push(.moviesByGenre(genreId))
    }

    public func navigateToMovieDetail(movieId: Int) {
        push(.movieDetails(movieId))
    }

    public func navigateToMovieReview(movieId: Int, movieTitle: String) {
        push(.movieReviews(movieId))
    }

    public func navigateToMovieTrailer(movieId: Int) {
        push(.movieTrailer(movieId))
    }
}
