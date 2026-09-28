//
//  Review.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation

public struct Review: Identifiable {
    public let id: String
    public let author: String
    public let authorDetails: AuthorDetails?
    public let content: String

    public init(id: String, author: String = "", authorDetails: AuthorDetails? = nil, content: String = "") {
        self.id = id
        self.author = author
        self.authorDetails = authorDetails
        self.content = content
    }
}
