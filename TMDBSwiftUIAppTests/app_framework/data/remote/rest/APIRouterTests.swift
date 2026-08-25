//
//  APIRouterTests.swift
//  TmdbMVVM-SwiftUI
//
//  Created by JAVARENT on 25/08/26.
//

import XCTest
import Alamofire

@testable import TmdbMVVM_SwiftUI

final class APIRouterTests: XCTestCase {
    
    // MARK: - Genre
    
    func test_fetchMovieGenre_shouldBuildCorrectRequest() throws {
        let request = try APIRouter.fetchMovieGenre.asURLRequest()
        
        XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
        XCTAssertEqual(request.url?.path, "/3/genre/movie/list")
        
        let components = try XCTUnwrap(URLComponents(url: try XCTUnwrap(request.url), resolvingAgainstBaseURL: false))
        
        let items = Dictionary(uniqueKeysWithValues: (components.queryItems ?? []).map {
            ($0.name, $0.value ?? "")
        })
        
        XCTAssertEqual(items["api_key"], DataConstants.API_KEY)
        
        XCTAssertEqual(items.count, 1)
    }
    
    // MARK: Discover
    
    func test_fetchMovieByGenre_shouldBuildCorrectRequest() throws {
        let request = try APIRouter.fetchMovieByGenre(genreId: "28", page: 3).asURLRequest()
        
        XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
        XCTAssertEqual(request.url?.path, "/3/discover/movie")
        
        let components = try XCTUnwrap(URLComponents(url: try XCTUnwrap(request.url), resolvingAgainstBaseURL: false))
        
        let items = Dictionary(uniqueKeysWithValues: (components.queryItems ?? []).map {
            ($0.name, $0.value ?? "")
        })
        
        XCTAssertEqual(items["api_key"], DataConstants.API_KEY)
        
        XCTAssertEqual(items["with_genres"], "28")
        XCTAssertEqual(items["page"], "3")
    }
    
    // MARK: Details
    
    func test_fetchMovieDetails_shouldBuildCorrectRequest() throws {
        let request = try APIRouter.fetchMovieDetail(movieId: 550).asURLRequest()
        
        XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
        XCTAssertEqual(request.url?.path, "/3/movie/550")
        
        let components = try XCTUnwrap(URLComponents(url: try XCTUnwrap(request.url), resolvingAgainstBaseURL: false))
        
        let items = Dictionary(uniqueKeysWithValues: (components.queryItems ?? []).map {
            ($0.name, $0.value ?? "")
        })
        
        XCTAssertEqual(items["language"], "en-US")
        XCTAssertEqual(items["api_key"], DataConstants.API_KEY)
    }
    
    // MARK: Reviews
    
    func test_fetchMovieReviews_shouldBuildCorrectRequest() throws {
        let request = try APIRouter.fetchMovieReviews(movieId: 550, page: 5).asURLRequest()
        
        XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
        XCTAssertEqual(request.url?.path, "/3/movie/550/reviews")
        
        let components = try XCTUnwrap(URLComponents(url: try XCTUnwrap(request.url), resolvingAgainstBaseURL: false))
        
        let items = Dictionary(uniqueKeysWithValues: (components.queryItems ?? []).map {
            ($0.name, $0.value ?? "")
        })
        
        XCTAssertEqual(items["page"], "5")
        XCTAssertEqual(items["language"], "en-US")
        XCTAssertEqual(items["api_key"], DataConstants.API_KEY)
    }
    
    // MARK: Trailer
    
    func test_fetchMovieTrailer_shouldBuildCorrectRequest() throws {
        let request = try APIRouter.fetchMovieTrailer(movieId: 550).asURLRequest()
        
        XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
        XCTAssertEqual(request.url?.path, "/3/movie/550/videos")
        
        let components = try XCTUnwrap(URLComponents(url: try XCTUnwrap(request.url), resolvingAgainstBaseURL: false))
        
        let items = Dictionary(uniqueKeysWithValues: (components.queryItems ?? []).map {
            ($0.name, $0.value ?? "")
        })
        
        XCTAssertEqual(items["language"], "en-US")
        XCTAssertEqual(items["api_key"], DataConstants.API_KEY)
    }
}
