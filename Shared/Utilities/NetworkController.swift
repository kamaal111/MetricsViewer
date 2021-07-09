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

    private let networker = MetricsNetworker(kowalskiAnalysis: false)
    private let cache = NetworkCache()

    private init() { }

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
        networker.getData(
            from: appIdentifier,
            withQueryItems: [],
            withHeader: headers) { (result: Result<[DataItemResponse]?, XiphiasNet.Errors>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                return
            case .success(let success):
                completion(.success(success))
                return
            }
        }
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
        networker.getRoot(with: appHeaders) { (result: Result<RootResponse?, XiphiasNet.Errors>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                return
            case .success(let success):
                completion(.success(success))
                return
            }
        }
    }

}
