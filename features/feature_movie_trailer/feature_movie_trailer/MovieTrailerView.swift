//
//  TrailerView.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import SwiftUI
import YouTubePlayerKit

public struct MovieTrailerView: View {
    @StateObject private var viewModel: MovieTrailerViewModel
    
    public init(viewModel: MovieTrailerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
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
