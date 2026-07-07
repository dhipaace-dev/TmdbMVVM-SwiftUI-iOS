//
//  TMDBClient.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation

final class TMDBClient {
    
    static func fetch<T: Decodable>(_ endpoint: String) async throws -> T {
        let url = URL(string: "\(TMDBConfig.baseURL)\(endpoint)&api_key=\(TMDBConfig.apiKey)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
