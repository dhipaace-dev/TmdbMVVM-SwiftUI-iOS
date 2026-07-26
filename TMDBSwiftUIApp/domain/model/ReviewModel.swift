//
//  ReviewModel.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation

public struct ReviewModel {
    public let results: [Review]

    public init(results: [Review] = []) {
        self.results = results
    }
}
