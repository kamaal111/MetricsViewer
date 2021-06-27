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

    private init() { }

    static let shared = NetworkController()

    func getRoot(completion: @escaping (Result<RootResponse?, Error>) -> Void) {
        if let response: RootResponse = cache.getCache(from: .root, with: "root") {
            completion(.success(response))
            return
        }
        networker.getRoot()
            .receive(on: DispatchQueue.global(), options: nil)
            .sink(receiveCompletion: { (subscriberCompletion: Subscribers.Completion<Error>) in
                switch subscriberCompletion {
                case .failure(let failure): completion(.failure(failure))
                case .finished: print("finished fetching")
                }
            }, receiveValue: { [weak self] (response: RootResponse?) in
                completion(.success(response))
                if let response = response {
                    self?.cache.setCache(this: response, in: .root, with: "root")
                }
            })
            .store(in: &subscriptions)
    }

}
