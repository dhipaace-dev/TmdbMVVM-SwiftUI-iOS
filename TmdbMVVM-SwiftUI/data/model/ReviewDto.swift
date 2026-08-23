//
//  Review.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation

struct ReviewDto: Identifiable, Decodable {
    let author: String?
    let authorDetails: AuthorDetailsDto?
    let content: String?
    let createdAt: String?//Date?
    let id: String?
    let updatedAt: String?//Date?
    let url: String?

    init(
        author: String? = nil,
        authorDetails: AuthorDetailsDto? = nil,
        content: String? = nil,
        createdAt: String?/*Date?*/ = nil,
        id: String? = nil,
        updatedAt: String?/*Date?*/ = nil,
        url: String? = nil
    ) {
        self.author = author
        self.authorDetails = authorDetails
        self.content = content
        self.createdAt = createdAt
        self.id = id
        self.updatedAt = updatedAt
        self.url = url
    }
    
    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}
