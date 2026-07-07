//
//  SplashView.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import SwiftUI

struct SplashView: View {
    let onFinish: () -> Void
    
    var body: some View {
        Text("TMDB App")
            .font(.largeTitle)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    onFinish()
                }
            }
    }
}
