//
//  SplashView.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import SwiftUI

public struct SplashView: View {
    let onFinish: () -> Void
    
    public init(onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
    }
    
    public var body: some View {
        Text("TMDB App")
            .font(.largeTitle)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    onFinish()
                }
            }
    }
}
