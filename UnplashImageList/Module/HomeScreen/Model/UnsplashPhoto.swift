//
//  Photos.swift
//  UnplashImageList
//
//  Created by Bishal Ram on 17/04/24.
//

import Foundation

struct UnsplashPhoto: Codable {
    let urls: URLs
}

struct URLs: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
    let smallS3: String
    
    private enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}
