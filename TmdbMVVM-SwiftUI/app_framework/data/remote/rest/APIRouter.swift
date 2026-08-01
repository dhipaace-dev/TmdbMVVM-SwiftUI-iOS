//
//  APIRouter.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation
import Alamofire
import SwiftyJSON

enum APIRouter: URLRequestConvertible {
    case fetchMovieGenre
    case fetchMovieByGenre(genreId: String, page: Int)
    case fetchMovieDetail(movieId: Int)
    case fetchMovieReviews(movieId: Int, page: Int)
    case fetchMovieTrailer(movieId: Int)
    
    var method: HTTPMethod {
        switch self {
        case .fetchMovieGenre, .fetchMovieByGenre, .fetchMovieDetail, .fetchMovieReviews, .fetchMovieTrailer:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchMovieGenre: return "3/genre/movie/list"
        case .fetchMovieByGenre(_, _):
            return "3/discover/movie"
        case let .fetchMovieDetail(movieId):
            return "3/movie/\(movieId)"
        case let .fetchMovieReviews(movieId, _):
            return "3/movie/\(movieId)/reviews"
        case let .fetchMovieTrailer(movieId):
            return "3/movie/\(movieId)/videos"
        }
    }
    
    var param: Parameters {
        var p = Parameters()

        //p["api_key"] = BuildConfiguration.shared.API_KEY
        
        let API_KEY = "bf5c57d57d1c81706c6ef4794e8d753e"
        p["api_key"] = API_KEY

        switch self {
        case .fetchMovieGenre:
            break
        case let .fetchMovieByGenre(genreId, page):
            p["with_genres"] = genreId
            p["page"] = page
        case .fetchMovieDetail(_):
            p["language"] = "en-US"
        case let .fetchMovieReviews(_, page):
            p["page"] = page
            p["language"] = "en-US"
        case .fetchMovieTrailer(_):
            p["language"] = "en-US"
        }

        return p
    }

    public func asURLRequest() throws -> URLRequest {
        //let url = URL(string: "\(BuildConfiguration.shared.API_BASE_URL)\(path)")
        let url = URL(string: "https://api.themoviedb.org/\(path)")

        if let theUrl = url {
            var urlRequest = URLRequest(url: theUrl)
            urlRequest.httpMethod = method.rawValue

            let encodedURLRequest: URLRequest

            if method == .get {
                encodedURLRequest = try URLEncoding.default.encode(urlRequest, with: param)
            } else {
                do {
                    urlRequest.httpBody = try JSON(param).rawData(options: .prettyPrinted)
                } catch {
                    print("httpBody failed!")
                }

                encodedURLRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            }

            return encodedURLRequest
        }

        throw NSError()
    }
}
