//
//  String+Extension.swift
//  UnplashImageList
//
//  Created by Bishal Ram on 17/04/24.
//

import Foundation

extension String {
    func asURL() -> URL? {
        return URL(string: self)
    }
}
