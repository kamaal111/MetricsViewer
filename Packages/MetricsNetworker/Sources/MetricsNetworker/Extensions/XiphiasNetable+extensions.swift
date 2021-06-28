//
//  XiphiasNetable+extensions.swift
//  
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import XiphiasNet
import Foundation

extension XiphiasNetable {
    func request<T: Codable>(
        from endpoint: Endpoint,
        with header: [String: String] = [:],
        completion: @escaping (Result<T?, XiphiasNet.Errors>) -> Void) {
        var urlRequest = URLRequest(url: endpoint.url)
        urlRequest.allHTTPHeaderFields = header
        request(from: urlRequest, completion: completion)
    }
}
