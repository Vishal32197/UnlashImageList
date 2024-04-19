//
//  GridViewCollectionViewCell.swift
//  UnplashImageList
//
//  Created by Bishal Ram on 17/04/24.
//

import UIKit
import Stevia

class GridViewCollectionViewCell: UICollectionViewCell {

    // MARK: // UI Companents
    let imageView: LazyImageView = {
        let imageView = LazyImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: // LifeCycle Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // MARK: // LifeCycle Methods
    private func setupLayout() {
        contentView.subviews {
            imageView
        }
        imageView.fillContainer()
    }
    
    // MARK: // Public Methods
    func setupContent(imageURL: URL) {
        imageView.loadImage(imageURL, "placeholder")
    }
}
