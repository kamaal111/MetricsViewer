//
//  MetricsNetworker.swift
//  
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import Foundation
import XiphiasNet
import ShrimpExtensions

public struct MetricsNetworker {
    private var kowalskiAnalysis: Bool
    private let networker: XiphiasNetable

    public init(kowalskiAnalysis: Bool = false) {
        self.networker = XiphiasNet(kowalskiAnalysis: kowalskiAnalysis)
        self.kowalskiAnalysis = kowalskiAnalysis
    }

    public func getRoot(completion: @escaping (Result<RootResponse?, XiphiasNet.Errors>) -> Void) {
        networker.request(from: .root, completion: completion)
    }
}
