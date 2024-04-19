//
//  NetworkError.swift
//  UnplashImageList
//
//  Created by Bishal Ram on 17/04/24.
//

import Foundation

enum NetworkError: Error {
    case failed
    case serverError(Int)
    case parsingError(Error)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failed:
            return "Something went Wrong!"
        case .serverError(let statusCode):
            switch statusCode {
            case 400:
                return "Network connection lost."
            case 401:
                return "Request Not Found"
            default:
                return "Something went Wrong! Please tryagain"
            }
        case .parsingError(let error):
            return error.localizedDescription
        }
    }
}
