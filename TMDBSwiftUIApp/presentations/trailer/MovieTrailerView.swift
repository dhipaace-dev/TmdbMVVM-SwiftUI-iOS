//
//  TrailerView.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import SwiftUI
import YouTubePlayerKit

struct MovieTrailerView: View {
    @StateObject private var viewModel: MovieTrailerViewModel
    
    init(viewModel: MovieTrailerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            if let movieKey = viewModel.movieKey, !movieKey.isEmpty, let url = URL(string: "https://www.youtube.com/watch?v=\(movieKey)") {
                YouTubePlayerView(
                    YouTubePlayer(
                        url: url
                    )
                )
                .frame(height: 250)
            } else {
                ProgressView()
            }
        }
        .task {
            viewModel.start()
        }
    }
}
