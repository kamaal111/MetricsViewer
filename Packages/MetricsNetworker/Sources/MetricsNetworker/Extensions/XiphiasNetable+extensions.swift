//
//  XiphiasNetable+extensions.swift
//  
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import XiphiasNet

extension XiphiasNetable {
    func request<T: Codable>(from endpoint: Endpoint, completion: @escaping (Result<T?, XiphiasNet.Errors>) -> Void) {
        request(from: endpoint.url, completion: completion)
    }
}
