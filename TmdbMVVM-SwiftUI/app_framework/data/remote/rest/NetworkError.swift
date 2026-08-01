//
//  NetworkError.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation
import Alamofire

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case unknown(statusCode: Int)
    case afError(AFError)
    
    var errorDescription: String? {
        switch self {
        case .unauthorized: return "Unauthorized (401)"
        case .forbidden: return "Forbidden (403)"
        case .notFound: return "Not Found (404)"
        case .serverError: return "Server Error"
        case .decodingError: return "Decoding Error"
        case .noData: return "No data received"
        case .invalidURL: return "Invalid URL"
        case .afError(let error): return error.localizedDescription
        case .unknown(let code): return "Unknown Error (status code: \(code))"
        }
    }
}
