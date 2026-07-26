//
//  GenreView.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import SwiftUI

struct GenreView: View {
    @StateObject private var viewModel: GenreViewModel
    @EnvironmentObject var router: Router
    
    init(viewModel: GenreViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List(viewModel.genres) { genre in
            Text(genre.name)
                .bold()
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.black, lineWidth: 1)
                )
                .onTapGesture {
                    router.push(.moviesByGenre(genre.id))
                }
        }
        .scrollContentBackground(.hidden)
        .background(.clear)
        .navigationTitle("Genres")
        .task {
            viewModel.start()
        }
        .overlay(content: {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)").foregroundColor(.red)
                }
            }
        })
    }
}
