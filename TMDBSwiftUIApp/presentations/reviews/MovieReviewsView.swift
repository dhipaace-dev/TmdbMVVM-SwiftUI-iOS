//
//  ReviewsView.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import SwiftUI
import Kingfisher

struct MovieReviewsView: View {
    @StateObject private var viewModel: MovieReviewsViewModel
    
    init(viewModel: MovieReviewsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List(viewModel.reviews) { review in
            VStack {
                Text(review.content)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                    .frame(height: 20)
                
                Text(review.author)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                KFImage(URL(string: review.authorDetails?.avatarPath ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipped()
            }
            .onAppear {
                viewModel.loadMoreReviewsIfNeeded(currentReview: review)
            }
        }
        .scrollContentBackground(.hidden)
        .background(.clear)
        .navigationTitle("Reviews")
        .task {
            viewModel.start()
        }
    }
}
