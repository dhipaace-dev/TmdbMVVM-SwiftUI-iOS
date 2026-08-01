//
//  AppError.swift
//  TmdbMVVMSwiftUIApp
//
//  Created by JAVARENT on 26/07/26.
//

import Foundation

public enum AppError: Error {
    case networkError(message: String)
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .networkError(message):
            return message
        }
    }
}

