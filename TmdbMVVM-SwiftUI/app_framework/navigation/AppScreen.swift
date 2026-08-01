//
//  AppScreen.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation

enum AppScreen: Hashable {
    case moviesByGenre(Int)
    case movieDetails(Int)
    case movieReviews(Int)
    case movieTrailer(Int)
}
