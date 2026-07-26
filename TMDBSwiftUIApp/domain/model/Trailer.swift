//
//  Trailer.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation

public struct Trailer {
    public let id: String
    public let key: String
    public let name: String
    public let site: String

    public init(id: String = "", key: String = "", name: String = "", site: String = "") {
        self.id = id
        self.key = key
        self.name = name
        self.site = site
    }
}
