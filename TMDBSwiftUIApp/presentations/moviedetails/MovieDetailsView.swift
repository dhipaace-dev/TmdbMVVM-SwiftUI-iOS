//
//  MovieDetailsView.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import SwiftUI

struct MovieDetailsView: View {
    let movieID: Int
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Movie ID: \(movieID)")
            
            Button("Show Reviews") {
                router.push(.movieReviews(movieID))
            }
            
            Button("Show Trailer") {
                router.push(.movieTrailer(movieID))
            }
        }
        .navigationTitle("Details")
    }
}
