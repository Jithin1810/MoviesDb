//
//  NetworkManager.swift
//  MoviesDb
//
//  Created by JiTHiN on 28/08/24.
//

import Foundation

protocol NetworkingClient {
    func request(url: URL, completion: @escaping ((_ data: Data?, _ error: Error?) -> Void))
}

class NetworkManager: NetworkingClient {
    func request(url: URL, completion: @escaping ((Data?, (any Error)?) -> Void)) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, url, error in
            completion(data, error)
        }
        task.resume()
    }
}
