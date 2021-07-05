//
//  MetricsNetworker.swift
//  
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import Foundation
import XiphiasNet
import ShrimpExtensions

/// Network utility for connecting to metrics-service API
public struct MetricsNetworker {
    private var kowalskiAnalysis: Bool
    private let networker: XiphiasNetable

    /// Initialize metrics networker with debug print statements
    ///
    /// Debug print statements are available if struct is initialised with `kowalskiAnalysis`.
    /// - Parameter kowalskiAnalysis: Initial as true to get debug print statements
    public init(kowalskiAnalysis: Bool = false) {
        self.networker = XiphiasNet(kowalskiAnalysis: kowalskiAnalysis)
        self.kowalskiAnalysis = kowalskiAnalysis
    }

    /// Get root to test connection to metrics-service API
    /// - Parameters:
    ///   - header: Request headers
    ///   - completion: Callback to get a result that returns ``RootResponse`` (AKA: test response) on success
    ///   and an `Error` from `XiphiasNet` on failure
    public func getRoot(
        with header: [String: String] = [:],
        completion: @escaping (Result<RootResponse?, XiphiasNet.Errors>) -> Void) {
        networker.request(from: .root, with: header, completion: completion)
    }
}
