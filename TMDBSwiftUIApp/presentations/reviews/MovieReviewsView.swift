//
//  ReviewsView.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import SwiftUI

struct MovieReviewsView: View {
    let movieId: Int
    
    var body: some View {
        Text("Reviews for movie \(movieId)")
            .navigationTitle("Reviews")
    }
}
