//
//  ReviewResponse.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation
//import domain

public struct ReviewResponse: Decodable {
    let id: Int?
    let page: Int?
    let results: [ReviewDto]?
    let totalPages: Int?
    let totalResults: Int?

    init(
        id: Int?,
        page: Int?,
        results: [ReviewDto]?,
        totalPages: Int?,
        totalResults: Int?
    ) {
        self.id = id
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

extension ReviewResponse {
    func toDomain() -> ReviewModel {
        let reviewEntities = results?.map { (review) -> Review in
            var imageUrl = review.authorDetails?.avatarPath ?? ""
            if imageUrl.starts(with: "/") {
                imageUrl.remove(at: imageUrl.startIndex)
            }

            if !imageUrl.starts(with: "http") {
                imageUrl = ""
            }

            let authorDetails = AuthorDetails(avatarPath: imageUrl)
            let reviewEntity = Review(
                id: review.id ?? "",
                author: review.author ?? "",
                authorDetails: authorDetails,
                content: review.content ?? ""
            )

            return reviewEntity
        }

        return ReviewModel(results: reviewEntities ?? [])
    }
}
