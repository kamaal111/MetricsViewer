//
//  AlertMessage.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 03/07/2021.
//

import Foundation

struct AlertMessage {
    let title: String
    let message: String?

    internal init(title: String, message: String? = nil) {
        self.title = title
        self.message = message
    }
}
