//
//  MetricsGridCellRenderable.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 08/07/2021.
//

import Foundation

public protocol MetricsGridCellRenderable: Hashable, Identifiable {
    var content: String { get }
    var id: UUID { get }
}

extension MetricsGridCellRenderable {
    var renderID: String {
        "\(content)-\(id)"
    }
}
