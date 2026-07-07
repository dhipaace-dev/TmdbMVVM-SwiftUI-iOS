//
//  Router.swift
//  TMDBSwiftUIApp
//
//  Created by JAVARENT on 07/07/26.
//

import Foundation
import SwiftUI

final class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ screen: AppScreen) {
        path.append(screen)
    }
    
    func pop() {
        path.removeLast()
    }
}
