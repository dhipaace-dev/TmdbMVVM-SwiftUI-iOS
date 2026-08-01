//
//  GenreModel.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation

public struct GenreModel {
    public let genres: [Genre]

    public init(genres: [Genre] = []) {
        self.genres = genres
    }
}
