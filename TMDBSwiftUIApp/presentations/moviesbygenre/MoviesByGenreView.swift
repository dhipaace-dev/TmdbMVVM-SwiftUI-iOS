//
//  MoviesByGenreView.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import SwiftUI

struct MoviesByGenreView: View {
    @StateObject private var viewModel: MoviesByGenreViewModel
    @EnvironmentObject var router: Router
    
    init(genreID: Int) {
        _viewModel = StateObject(wrappedValue: MoviesByGenreViewModel(genreID: genreID))
    }
    
    var body: some View {
        List(viewModel.movies) { movie in
            Button(movie.title) {
                router.push(.movieDetails(movie.id))
            }
        }
        .navigationTitle("Movies")
        .task {
            await viewModel.loadMovies()
        }
    }
}
