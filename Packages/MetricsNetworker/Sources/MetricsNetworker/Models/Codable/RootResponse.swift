//
//  RootResponse.swift
//  
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import Foundation

/// An encoded response from root endpoint
public struct RootResponse: Codable {
    public let hello: String
    public let message: String
}
