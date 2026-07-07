//
//  ContentView.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var router = Router()
    @State private var showSplash = true
    
    var body: some View {
        if showSplash {
            SplashView {
                showSplash = false
            }
        } else {
            NavigationStack(path: $router.path) {
                GenreView()
                    .environmentObject(router)
                    .navigationDestination(for: AppScreen.self) { screen in
                        switch screen {
                        case .moviesByGenre(let id):
                            MoviesByGenreView(genreID: id)
                        case .movieDetails(let id):
                            MovieDetailsView(movieID: id)
                        case .movieReviews(let id):
                            MovieReviewsView(movieId: id)
                        case .movieTrailer(let id):
                            MovieTrailerView(movieID: id)
                        }
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
