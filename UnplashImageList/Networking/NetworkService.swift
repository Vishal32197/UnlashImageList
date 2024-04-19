//
//  NetworkService.swift
//  UnplashImageList
//
//  Created by Bishal Ram on 17/04/24.
//

import Foundation

typealias completionHandler = (([UnsplashPhoto]?, NetworkError?) -> Void)

protocol NetworkServiceProtocol {
    func request(route: Route,
                 method: HTTPMethod,
                 params: [String: String],
                 completion: @escaping completionHandler)
}

class NetworkService: NetworkServiceProtocol {
    
    func request(route: Route,
                 method: HTTPMethod,
                 params: [String: String],
                 completion: @escaping completionHandler) {
        
        
        guard let url = URL(string: Environment.test.baseURL) else {
            return
        }
        
        var components = URLComponents(url: url.appendingPathComponent(route.rawValue), resolvingAgainstBaseURL: false)
        
        components?.queryItems = params.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        guard let finalURL = components?.url else {
            return
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, .parsingError(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
            if httpResponse.statusCode == Constants.SuccessNetworkStatusCode {
                guard let data = data else {
                    return
                }
                do {
                    let jsonData = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
                    completion(jsonData, nil)
                }
                catch {
                    completion(nil, .failed)
                }
            } else {
                completion(nil, .serverError(httpResponse.statusCode))
                return
            }
            
        }.resume()
    }
}
