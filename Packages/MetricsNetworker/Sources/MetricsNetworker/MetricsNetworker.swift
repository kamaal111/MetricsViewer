//
//  MetricsNetworker.swift
//  
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import Foundation
import XiphiasNet
import ShrimpExtensions

/// Generic protocol to ensure the creation of an valid `URLQueryItem`
public protocol NetworkQueryable {
    /// Generic enum with an rawValue of `String`
    associatedtype Enum: RawRepresentable where Enum.RawValue == String
    /// Generic key from enum
    var key: Enum { get set }
    /// Query item value
    var value: String { get set }
}

extension NetworkQueryable {
    var urlQueryItem: URLQueryItem {
        URLQueryItem(name: key.rawValue, value: value)
    }
}

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
    ///   - headers: Request headers
    ///   - completion: Callback to get a result that returns ``RootResponse`` (AKA: test response) on success
    ///   and an `Error` from `XiphiasNet` on failure
    public func getRoot(
        with headers: [String: String] = [:],
        completion: @escaping (Result<RootResponse?, XiphiasNet.Errors>) -> Void) {
        networker.request(from: .root, with: headers, completion: completion)
    }

    /// Get data returns an result of an array of ``DataItemResponse``'s in it's completion handler
    /// from the metrics-service API
    /// - Parameters:
    ///   - appIdentifier: is the identifier of the app that you want to request data from,
    ///   for example `com.companyName.appNam`
    ///   - queryItems: to query on the endpoint
    ///   - headers: request headers
    ///   - completion: completion handlers returns an result of an array of ``DataItemResponse``'s on success
    ///   and an `Error` from `XiphiasNet` on failure
    public func getData(
        from appIdentifier: String,
        withQueryItems queryItems: [GetDataQueryItem] = [],
        withHeader headers: [String: String] = [:],
        completion: @escaping (Result<[DataItemResponse]?, XiphiasNet.Errors>) -> Void) {
        networker.request(
            from: .data(from: appIdentifier, with: queryItems.map(\.urlQueryItem)),
            with: headers,
            completion: completion)
    }

    /// Query with enum valued key
    public struct GetDataQueryItem: NetworkQueryable {
        public var key: MetricsNetworker.GetDataQueryKey
        public var value: String

        public init(key: MetricsNetworker.GetDataQueryKey, value: String) {
            self.key = key
            self.value = value
        }
    }

    /// Available query keys for ``getData(from:withQueryItems:withHeader:completion:)``
    public enum GetDataQueryKey: String {
        case appVersion = "app_version"
    }
}
