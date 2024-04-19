//
//  LazyImageView.swift
//  UnplashImageList
//
//  Created by Bishal Ram on 17/04/24.
//

import Foundation
import UIKit

class LazyImageView: UIImageView {
    
    private let imageCache = NSCache<AnyObject, UIImage>()
    
    func loadImage(_ imageURL: URL, _ placeholderImage: String) {
        
        self.image = UIImage(named: placeholderImage)
        
        if let cachedImage = self.imageCache.object(forKey: imageURL as AnyObject) {
            self.image = cachedImage
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: imageURL) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.imageCache.setObject(image, forKey: imageURL as AnyObject)
                        self?.image = image
                    }
                }
            }
        }
    }
}
