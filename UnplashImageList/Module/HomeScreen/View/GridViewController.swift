//
//  GridViewController.swift
//  UnplashImageList
//
//  Created by Bishal Ram on 17/04/24.
//

import UIKit
import Stevia

class GridViewController: UIViewController {
    
    // MARK: // Properties
    private var viewModel: GridViewModelProtocol
    
    // MARK: // Initialization
    init(viewModel: GridViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: // UI Components
    private lazy var imageListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(GridViewCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private let errorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: // LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewLayout()
        setupErrorView()
        bindViewModel()
        viewModel.fetchImages(page: viewModel.currentPage)
    }
    
    // MARK: // Private Methods
    private func setupViewLayout() {
        self.view.backgroundColor = .white
        self.view.subviews {
            imageListCollectionView
        }
        
        imageListCollectionView.fillContainer()
    }
    
    private func setupErrorView() {
        view.subviews {
            errorView
        }
        
        errorView.subviews {
            errorMessageLabel
        }
        
        errorMessageLabel.CenterY == view.CenterY
        errorMessageLabel.CenterX == view.CenterX
    }
    
    private func bindViewModel() {
        viewModel.onDataUpdate = { result in
            switch result {
            case .success(let status):
                if status {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.imageListCollectionView.reloadData()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.errorMessageLabel.text = error.errorDescription
                }
            }
        }
    }
}

extension GridViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: // UIColletctionView Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GridViewCollectionViewCell
     
        cell.setupContent(imageURL: viewModel.imageURLs[indexPath.row].asURL()!)
        return cell
    }
    
    // MARK: // UIColletctionView Delegate
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
   
        if indexPath.row == viewModel.imageURLs.count - 1 {
            let nextPage = viewModel.currentPage + 1
            viewModel.currentPage = nextPage
            if nextPage <= 300 {
                self.viewModel.fetchImages(page: nextPage)
            }
        }
    }
}
