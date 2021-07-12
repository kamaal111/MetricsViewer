//
//  handledAlert.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 10/07/2021.
//

import SwiftUI

func handledAlert(with alertMessage: AlertMessage?) -> Alert {
    guard let view = alertMessage?.view else {
        return Alert(title: Text(localized: .GENERAL_ALERT_TITLE))
    }
    return view
}
