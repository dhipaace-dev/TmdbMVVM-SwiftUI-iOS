//
//  ErrorResponse.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation

public struct ErrorResponse: Decodable {
    let success: Bool?
    let statusCode: Int?
    public let statusMessage: String?

    init(success: Bool? = nil, statusCode: Int? = nil, statusMessage: String? = nil) {
        self.success = success
        self.statusCode = statusCode
        self.statusMessage = statusMessage
    }
    
    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
