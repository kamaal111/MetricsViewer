//
//  Histogram.swift
//  
//
//  Created by Kamaal M Farah on 10/07/2021.
//

import Foundation

public struct Histogram: Codable {
    public let histogramNumBuckets: Int?
    public let histogramValue: [String: HistogramValue]?
}

extension Histogram {
    /// Average value of all `histogramValue's`
    public var averageValue: Int? {
        guard let histogramValue = histogramValue else { return nil }
        let sum = histogramValue.reduce(0, { partialResult, item in
            let value = item.value
            guard let bucketStart = Int(value.bucketStart.digits),
                  let bucketEnd = Int(value.bucketEnd.digits) else {
                      return partialResult
                  }
            return partialResult + (bucketEnd - bucketStart)
        })
        return sum / histogramValue.count
    }

    public struct HistogramValue: Codable {
        public let bucketCount: Int
        public let bucketStart: String
        public let bucketEnd: String
    }
}
