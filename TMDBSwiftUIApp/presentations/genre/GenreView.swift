//
//  GenreView.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import SwiftUI

struct GenreView: View {
    @StateObject private var viewModel = GenreViewModel()
    @EnvironmentObject var router: Router
    
    var body: some View {
        List(viewModel.genres) { genre in
            Button(genre.name) {
                router.push(.moviesByGenre(genre.id))
            }
        }
        .navigationTitle("Genres")
        .task {
            await viewModel.loadGenres()
        }
    }
}
