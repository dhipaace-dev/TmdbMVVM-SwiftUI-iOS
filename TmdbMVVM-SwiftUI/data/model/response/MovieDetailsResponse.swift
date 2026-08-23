//
//  MovieResponse.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation
//import domain

public struct MovieDetailsResponse: Decodable {
    let adult: Bool?
    let backdropPath: String?
    //let belongs_to_collection: Any?
    let budget: Int?
    let genres: [GenreDto]?
    let homepage: String?
    let id: Int?
    let imdbId: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Float?
    let posterPath: String?
    let productionCompanies: [ProductionCompanyDto]?
    let productionCountries: [ProductionCountryDto]?
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let spokenLanguages: [SpokenLanguageDto]?
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let voteAverage: Float?
    let voteCount: Int?

    init(
        adult: Bool? = nil,
        backdropPath: String? = nil,
        //belongs_to_collection: Any?,
        budget: Int? = nil,
        genres: [GenreDto]? = nil,
        homepage: String? = nil,
        id: Int? = nil,
        imdbId: String? = nil,
        originalLanguage: String? = nil,
        originalTitle: String? = nil,
        overview: String? = nil,
        popularity: Float? = nil,
        posterPath: String? = nil,
        productionCompanies: [ProductionCompanyDto]? = nil,
        productionCountries: [ProductionCountryDto]? = nil,
        releaseDate: String? = nil,
        revenue: Int? = nil,
        runtime: Int? = nil,
        spokenLanguages: [SpokenLanguageDto]? = nil,
        status: String? = nil,
        tagline: String? = nil,
        title: String? = nil,
        video: Bool? = nil,
        voteAverage: Float? = nil,
        voteCount: Int? = nil
    ) {
        self.adult = adult
        self.backdropPath = backdropPath
        //self.belongs_to_collection = belongs_to_collection
        self.budget = budget
        self.genres = genres
        self.homepage = homepage
        self.id = id
        self.imdbId = imdbId
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.releaseDate = releaseDate
        self.revenue = revenue
        self.runtime = runtime
        self.spokenLanguages = spokenLanguages
        self.status = status
        self.tagline = tagline
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        //case belongs_to_collection
        case budget
        case genres
        case homepage
        case id
        case imdbId = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension MovieDetailsResponse {
    func toDomain() -> MovieDetailsModel {
        return MovieDetailsModel(
            id: self.id ?? -1,
            overview: self.overview ?? "",
            title: self.title ?? "",
            imageUrl: (!(posterPath?.isEmpty ?? true)) ? DataConstants.IMAGE_URL_BASE_PATH + (posterPath ?? "") : ""
        )
    }
}
