//
//  MovieResponse.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation

struct MovieResponse: Decodable {
    let results: [Movie]
}
