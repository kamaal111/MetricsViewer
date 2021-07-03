//
//  NetworkCache.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import Foundation

final class NetworkCache {

    private var cache: [CacheKeys: [String: Data]]
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let queue = DispatchQueue.networkCache

    init() {
        var cache: [CacheKeys: [String: Data]] = [:]
        for key in CacheKeys.allCases {
            cache[key] = [:]
        }
        self.cache = cache
    }

    enum CacheKeys: CaseIterable {
        case root
    }

    func getCache<T: Codable>(from cacheKey: CacheKeys, with objectKey: String, completion: @escaping (T?) -> Void) {
        queue.async { [weak self] in
            guard let self = self, let data = self.cache[cacheKey]?[objectKey] else {
                completion(nil)
                return
            }
            let decodedData = try? self.decoder.decode(T.self, from: data)
            completion(decodedData)
        }

    }

    func setCache<T: Codable>(this object: T, in cacheKey: CacheKeys, with objectKey: String) {
        queue.async { [weak self] in
            guard let self = self, let data = try? self.encoder.encode(object) else { return }
            self.cache[cacheKey]?[objectKey] = data
        }
    }

}
