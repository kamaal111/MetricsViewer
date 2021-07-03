//
//  NetworkController.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import Foundation
import Combine
import MetricsNetworker

class NetworkController {

    var subscriptions = Set<AnyCancellable>()
    let networker = MetricsNetworker(kowalskiAnalysis: false)

    private let cache = NetworkCache()
    private let queue = DispatchQueue.global()

    private init() { }

    static let shared = NetworkController()

    func getRoot(completion: @escaping (Result<RootResponse?, Error>) -> Void) {
        let cacheObjectKey = "root"
        self.cache.getCache(from: .root, with: cacheObjectKey) { [weak self] (response: RootResponse?) in
            guard let self = self else {
                completion(.success(nil))
                return
            }
            self.queue.async { [weak self] in
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
    }

    private func handleUncachedRoot(cacheObjectKey: String, completion: @escaping (Result<RootResponse?, Error>) -> Void) {
        networker.getRoot()
            .receive(on: queue, options: nil)
            .sink(receiveCompletion: { (subscriberCompletion: Subscribers.Completion<Error>) in
                switch subscriberCompletion {
                case .failure(let failure): completion(.failure(failure))
                case .finished: print("finished fetching")
                }
            }, receiveValue: { [weak self] (response: RootResponse?) in
                completion(.success(response))
                if let response = response {
                    self?.cache.setCache(this: response, in: .root, with: cacheObjectKey)
                }
            })
            .store(in: &subscriptions)
    }

}
