//
//  NetworkController.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import Foundation
import MetricsNetworker
import XiphiasNet

class NetworkController {

    private let networker: MetricsNetworker
    private let cache: NetworkCache

    private init() {
        self.networker = MetricsNetworker(kowalskiAnalysis: false)
        self.cache = NetworkCache()
    }

    static let shared = NetworkController()

    let appHeaders: [String: String] = [
        "version": "1.0.1"
    ]

    func getData(
        from appIdentifier: String,
        using accessToken: String,
        completion:  @escaping (Result<[DataItemResponse]?, XiphiasNet.Errors>) -> Void) {
        var headers = appHeaders
        headers["access_token"] = accessToken
        networker.getData(from: appIdentifier, withQueryItems: [], withHeader: headers, completion: completion)
    }

    func getRoot(completion: @escaping (Result<RootResponse?, XiphiasNet.Errors>) -> Void) {
        let cacheObjectKey = "root"
        self.cache.getCache(from: .root, with: cacheObjectKey) { [weak self] (response: RootResponse?) in
            guard let self = self else {
                completion(.success(nil))
                return
            }
            if let response = response {
                completion(.success(response))
                return
            }
            self.handleUncachedRoot(cacheObjectKey: cacheObjectKey, completion: completion)
        }
    }

    private func handleUncachedRoot(
        cacheObjectKey: String,
        completion: @escaping (Result<RootResponse?, XiphiasNet.Errors>) -> Void) {
        networker.getRoot(with: appHeaders) { [weak self] (result: Result<RootResponse?, XiphiasNet.Errors>) in
            let response: RootResponse?
            switch result {
            case .failure(let error):
                completion(.failure(error))
                return
            case .success(let success):
                response = success
            }
            if let response = response {
                self?.cache.setCache(this: response, in: .root, with: cacheObjectKey)
            }
            completion(.success(response))
        }
    }

}
