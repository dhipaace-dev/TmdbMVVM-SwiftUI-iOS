//
//  TrailerView.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import SwiftUI

struct MovieTrailerView: View {
    let movieID: Int
    
    var body: some View {
        Text("Trailer for movie \(movieID)")
            .navigationTitle("Trailer")
    }
}
