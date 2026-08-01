//
//  ContentView.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var navigationService = NavigationService()
    
    private let apiClient: ApiClient
    private let appDataSource: AppDataSource
    private let repository: AppRepository
    private let getMovieGenreUseCase: GetMovieGenreUseCase
    private let getMovieByGenreUseCase: GetMovieByGenreUseCase
    private let getMovieDetailsUseCase: GetMovieDetailsUseCase
    private let getMovieReviewUseCase: GetMovieReviewUseCase
    private let getMovieTrailerUseCase: GetMovieTrailerUseCase
    private let genreViewModel: GenreViewModel
    
    @State private var showSplash = true
    
    init() {
        let apiClient = ApiClient()
        let appDataSource = RemoteDataSourceImpl(apiClient: apiClient)
        let repository = AppRepositoryImpl(appDataSource: appDataSource)
        let getMovieGenreUseCase = GetMovieGenreUseCaseImpl(
            appRepository: repository
        )
        let getMovieByGenreUseCase = GetMovieByGenreUseCaseImpl(
            appRepository: repository
        )
        let getMovieDetailsUseCase = GetMovieDetailsUseCaseImpl(
            appRepository: repository
        )
        let getMovieReviewUseCase = GetMovieReviewUseCaseImpl(
            appRepository: repository
        )
        let getMovieTrailerUseCase = GetMovieTrailerUseCaseImpl(
            appRepository: repository
        )

        self.apiClient = apiClient
        self.appDataSource = appDataSource
        self.repository = repository
        self.getMovieGenreUseCase = getMovieGenreUseCase
        self.getMovieByGenreUseCase = getMovieByGenreUseCase
        self.getMovieDetailsUseCase = getMovieDetailsUseCase
        self.getMovieReviewUseCase = getMovieReviewUseCase
        self.getMovieTrailerUseCase = getMovieTrailerUseCase
        
        self.genreViewModel = GenreViewModel(
            getMovieGenreUseCase: getMovieGenreUseCase
        )
    }
    
    var body: some View {
        if showSplash {
            SplashView {
                showSplash = false
            }
        } else {
            NavigationStack(path: $navigationService.path) {
                GenreView(viewModel: genreViewModel)
                    .navigationDestination(for: AppScreen.self) { screen in
                        switch screen {
                        case .moviesByGenre(let id):
                            MoviesByGenreView(
                                viewModel: MoviesByGenreViewModel(
                                    genreId: id,
                                    getMovieByGenreUseCase: getMovieByGenreUseCase
                                )
                            )
                        case .movieDetails(let id):
                            MovieDetailsView(
                                movieId: id,
                                viewModel: MovieDetailsViewModel(
                                    movieId: id,
                                    getMovieDetailsUseCase: getMovieDetailsUseCase
                                )
                            )
                        case .movieReviews(let id):
                            MovieReviewsView(
                                viewModel: MovieReviewsViewModel(movieId: id, getMovieReviewUseCase: getMovieReviewUseCase
                                                                )
                            )
                        case .movieTrailer(let id):
                            MovieTrailerView(
                                viewModel: MovieTrailerViewModel(movieId: id, getMovieTrailerUseCase: getMovieTrailerUseCase)
                            )
                        }
                    }
            }
            .environmentObject(navigationService)
        }
    }
}

#Preview {
    ContentView()
}
