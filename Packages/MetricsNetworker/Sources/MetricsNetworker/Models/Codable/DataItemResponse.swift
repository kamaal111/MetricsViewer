//
//  DataItemResponse.swift
//  
//
//  Created by Kamaal Farah on 09/07/2021.
//

import Foundation

public struct DataItemResponse: Codable, Identifiable {
    public let id: Int
    public let appVersion: String
    public let appBuildVersion: String
    public let payload: Payload

    enum CodingKeys: String, CodingKey {
        case id
        case appVersion = "app_version"
        case appBuildVersion = "app_build_version"
        case payload
    }
}

extension DataItemResponse {
    public struct Payload: Codable {
        public let locationActivityMetrics: LocationActivityMetrics
    }
}

extension DataItemResponse.Payload {
    public struct LocationActivityMetrics: Codable {
        public let cumulativeBestAccuracyForNavigationTime: String
    }
}
