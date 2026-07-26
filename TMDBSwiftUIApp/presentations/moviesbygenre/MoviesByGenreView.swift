//
//  MoviesByGenreView.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import SwiftUI
import Kingfisher

struct MoviesByGenreView: View {
    @StateObject private var viewModel: MoviesByGenreViewModel
    @EnvironmentObject var router: Router
    
    init(viewModel: MoviesByGenreViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List(viewModel.movies) { movie in
            HStack {
                KFImage(URL(string: movie.imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 150)
                    .clipped()
                
                VStack {
                    Text(movie.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(movie.overview)
                        .lineLimit(5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                }
                
            }
            .onTapGesture {
                router.push(.movieDetails(movie.id))
            }
            .onAppear {
                viewModel.loadMoreMoviesIfNeeded(currentMovie: movie)
            }
        }
        .scrollContentBackground(.hidden)
        .background(.clear)
        .navigationTitle("Movies")
        .task {
            viewModel.start()
        }
    }
}
