//
//  MovieDetailsView.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import SwiftUI
import Kingfisher

struct MovieDetailsView: View {
    let movieId: Int
    @StateObject private var viewModel: MovieDetailsViewModel
    @EnvironmentObject var router: Router
    
    init(movieId: Int, viewModel: MovieDetailsViewModel) {
        self.movieId = movieId
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(viewModel.movie?.title ?? "")
                    .bold()
                
                Text(viewModel.movie?.overview ?? "")
                
                Spacer()
                
                KFImage(URL(string: viewModel.movie?.imageUrl ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 300)
                    .clipped()
                
                Spacer()
                
                Button("Show Reviews") {
                    router.push(.movieReviews(movieId))
                }
                
                Button("Show Trailer") {
                    router.push(.movieTrailer(movieId))
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .task {
            viewModel.start()
        }
        .overlay(content: {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)").foregroundColor(.red)
                }
            }
        })
    }
}
