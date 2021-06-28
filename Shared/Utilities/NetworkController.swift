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

    let networker = MetricsNetworker(kowalskiAnalysis: false)

    private let cache = NetworkCache()

    private init() { }

    static let shared = NetworkController()

    func getRoot(completion: @escaping (Result<RootResponse?, XiphiasNet.Errors>) -> Void) {
        if let response: RootResponse = cache.getCache(from: .root, with: "root") {
            completion(.success(response))
            return
        }
        networker.getRoot { [weak self] (result: Result<RootResponse?, XiphiasNet.Errors>) in
            let response: RootResponse?
            switch result {
            case .failure(let failure):
                completion(.failure(failure))
                return
            case .success(let success): response = success
            }
            completion(.success(response))
            if let response = response {
                self?.cache.setCache(this: response, in: .root, with: "root")
            }
        }
    }

}
