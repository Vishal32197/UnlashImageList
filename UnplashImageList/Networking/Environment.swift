//
//  Environment.swift
//  UnplashImageList
//
//  Created by Bishal Ram on 17/04/24.
//

import Foundation

enum Environment {
    case test
}

extension Environment {
    var baseURL: String {
        switch self {
        case .test:
            return "https://api.unsplash.com/"
        }
    }
    
    var apiKey: String {
        switch self {
        case .test:
            return Constants.APIKey
        }
    }
}
