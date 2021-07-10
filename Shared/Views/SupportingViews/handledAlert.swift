//
//  handledAlert.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 10/07/2021.
//

import SwiftUI

func handledAlert(with alertMessage: AlertMessage?) -> Alert {
    guard let alertMessage = alertMessage else {
        return Alert(title: Text(localized: .GENERAL_ALERT_TITLE))
    }
    var messageText: Text?
    if let message = alertMessage.message {
        messageText = Text(message)
    }
    return Alert(title: Text(alertMessage.title), message: messageText)
}
