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

    func getCache<T: Codable>(from cacheKey: CacheKeys, with objectKey: String) -> T? {
        guard let data = cache[cacheKey]?[objectKey] else { return nil }
        let decodedData = try? decoder.decode(T.self, from: data)
        return decodedData
    }

    func setCache<T: Codable>(this object: T, in cacheKey: CacheKeys, with objectKey: String) {
        guard let data = try? encoder.encode(object) else { return }
        cache[cacheKey]?[objectKey] = data
    }

}
