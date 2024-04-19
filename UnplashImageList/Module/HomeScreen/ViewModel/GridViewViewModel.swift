//
//  GridViewViewModel.swift
//  UnplashImageList
//
//  Created by Bishal Ram on 17/04/24.
//

import Foundation

protocol GridViewModelProtocol {
    var onDataUpdate: ((Result<Bool, NetworkError>) -> Void)? { get set }
    var currentPage: Int { get set }
    var imageURLs: [String] { get }
    func fetchImages(page: Int)
}

final class GridViewViewModel: GridViewModelProtocol {
    
    // MARK: // Private Properties
    private let networkService: NetworkServiceProtocol
    private var dataSource: [UnsplashPhoto] = []
    
    // MARK: // Protocol Properties
    var imageURLs: [String] = []
    var currentPage: Int = 1
    var onDataUpdate: ((Result<Bool, NetworkError>) -> Void)?
    
    // MARK: // Initialisation
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: // Network Call Methods
    func fetchImages(page: Int) {
        let params = ["client_id": Environment.test.apiKey,
                      "per_page": Constants.PageCount,
                      "page": String(page)]
        
        networkService.request(route: .fetchData, method: .get, params: params) { [weak self] response, error  in
            
            guard let self = self else { return }
            if let error = error {
                self.onDataUpdate?(.failure(error))
                return
            } else {
                if let response = response {
                    self.dataSource.append(contentsOf: response)
                    self.imageURLs = dataSource.compactMap { $0.urls }.map { $0.regular }
                    self.onDataUpdate?(.success(true))
                }
            }
        }
    }
}

