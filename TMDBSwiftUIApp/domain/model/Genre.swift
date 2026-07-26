//
//  Genre.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation

public struct Genre: Identifiable {
    public let id: Int
    public let name: String

    public init(id: Int = -1, name: String = "") {
        self.id = id
        self.name = name
    }
}
