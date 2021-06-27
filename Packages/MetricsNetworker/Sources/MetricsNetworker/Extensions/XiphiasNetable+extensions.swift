//
//  XiphiasNetable+extensions.swift
//  
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import XiphiasNet
import Combine

extension XiphiasNetable {
    func requestPublisher<T: Codable>(from endpoint: Endpoint) -> AnyPublisher<T?, Error> {
        requestPublisher(from: endpoint.url)
    }
}
