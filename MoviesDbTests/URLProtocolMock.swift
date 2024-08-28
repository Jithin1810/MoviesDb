//
//  URLProtocolMock.swift
//  MoviesDbTests
//
//  Created by JiTHiN on 27/08/24.
//

import Foundation
@testable import MoviesDb

class URLProtocolMock: URLProtocol {
    static var testURLs = [URL: Data?]()
    static var testError: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = URLProtocolMock.testError {
            client?.urlProtocol(self, didFailWithError: error)
        } else if let data = URLProtocolMock.testURLs[request.url!] {
            client?.urlProtocol(self, didReceive: HTTPURLResponse(), cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {
        // No-op
    }
}


class MockNetworkManager: NetworkingClient {
    func request(url: URL, completion: @escaping ((Data?, (any Error)?) -> Void)) {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { data, url, error in
            completion(data, error)
        }
        task.resume()
    }
}
