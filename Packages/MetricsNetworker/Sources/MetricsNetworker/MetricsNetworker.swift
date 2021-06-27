//
//  MetricsNetworker.swift
//  
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import Foundation
import XiphiasNet
import ShrimpExtensions
import Combine

public struct MetricsNetworker {
    private var kowalskiAnalysis: Bool
    private let networker: XiphiasNetable

    public init(kowalskiAnalysis: Bool = false) {
        self.networker = XiphiasNet(kowalskiAnalysis: kowalskiAnalysis)
        self.kowalskiAnalysis = kowalskiAnalysis
    }

    public func getRoot() -> AnyPublisher<RootResponse?, Error> {
        networker.requestPublisher(from: .root)
    }
}
