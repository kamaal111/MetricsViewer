//
//  Dictionary+extensions.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 16/07/2021.
//

import Foundation

extension Dictionary {
    func merged(with dict: [Key: Value]) -> [Key: Value] {
        var mergedDict = self
        for (key, value) in dict {
            mergedDict[key] = value
        }
        return mergedDict
    }
}
