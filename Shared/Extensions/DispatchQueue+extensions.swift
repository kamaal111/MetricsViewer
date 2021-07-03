//
//  DispatchQueue+extensions.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 03/07/2021.
//

import Foundation

extension DispatchQueue {
    static let networkCache = DispatchQueue(label: constructLabel(with: "network-cache"), qos: .utility)

    private static func constructLabel(with key: String) -> String {
        "\(Constant.appIdentifier).\(key)"
    }
}
