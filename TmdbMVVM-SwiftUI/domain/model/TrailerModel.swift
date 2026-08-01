//
//  TrailerModel.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation

public struct TrailerModel {
    public let id: Int
    public let results: [Trailer]

    public init(id: Int = -1, results: [Trailer] = []) {
        self.id = id
        self.results = results
    }
}
