//
//  AlertMessage.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 03/07/2021.
//

import Foundation
import MetricsLocale
import SwiftUI

struct AlertMessage {
    let title: String
    let message: String?

    init(title: String, message: String? = nil) {
        self.title = title
        self.message = message
    }

    init(title: MetricsLocale.Keys, message: MetricsLocale.Keys? = nil) {
        self.init(title: title.localized, message: message?.localized)
    }

    var view: Alert {
        var messageText: Text?
        if let message = message {
            messageText = Text(message)
        }
        return Alert(title: Text(title), message: messageText)
    }
}
