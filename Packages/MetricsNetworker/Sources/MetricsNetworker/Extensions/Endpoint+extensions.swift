//
//  Endpoint+extensions.swift
//  
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import Foundation

extension Endpoint {
    static let root = Endpoint(path: "")

    static func data(from appIdentifier: String, with queryItems: [URLQueryItem] = []) -> Endpoint {
        Endpoint(path: "metrics/data/\(appIdentifier)", queryItems: queryItems)
    }
}
