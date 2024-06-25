//
//  NetworkService.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 10/06/2024.
//

import Foundation
import UIKit

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
    case imageDownloadFailed
}

class NetworkService {
    static let shared = NetworkService()

    private init() {}

    func request<T: Decodable>(urlString: String, completion: @escaping (Result<T, APIError>) -> Void) {
        guard isValidURL(urlString: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(.failure(.requestFailed))
                return
            }

            guard let data else {
                completion(.failure(.requestFailed))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }

        task.resume()
    }

    func isValidURL(urlString: String) -> Bool {
        guard let url = URL(string: urlString) else {
            return false
        }

        return UIApplication.shared.canOpenURL(url)
    }
}

