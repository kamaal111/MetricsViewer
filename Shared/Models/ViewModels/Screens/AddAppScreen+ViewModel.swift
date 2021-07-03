//
//  AddAppScreen+ViewModel.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 03/07/2021.
//

import Foundation
import Combine
import ShrimpExtensions

extension AddAppScreen {
    final class ViewModel: ObservableObject {

        @Published var appName = ""
        @Published var appIdentifier = ""
        @Published var accessToken = ""
        @Published var showAlert = false
        @Published private(set) var alertMessage: AlertMessage? {
            didSet {
                if !showAlert && alertMessage != nil {
                    showAlert = true
                } else if showAlert && alertMessage == nil {
                    showAlert = false
                }
            }
        }

        enum FormValidationErrors: Error {
            case appNameMissing
            case invalidAppIdentifier
            case invalidAccessToken

            var alertMessage: AlertMessage {
                switch self {
                case .appNameMissing:
                    // - TODO: LOCALIZE THIS
                    return AlertMessage(title: "App name is missing")
                case .invalidAppIdentifier:
                    // - TODO: LOCALIZE THIS
                    return AlertMessage(title: "Invalid app identifier")
                case .invalidAccessToken:
                    return AlertMessage(title: "Invalid access token")
                }
            }
        }

        func onDoneEditing() {
            do {
                try validateForm()
            } catch {
                if let error = error as? FormValidationErrors {
                    alertMessage = error.alertMessage
                }
                return
            }
            print("done")
        }

        private func validateForm() throws {
            guard !appName.trimmingByWhitespacesAndNewLines.isEmpty else {
                throw FormValidationErrors.appNameMissing
            }
            guard appIdentifier.trimmingByWhitespacesAndNewLines.split(separator: ".").count > 1 else {
                throw FormValidationErrors.invalidAppIdentifier
            }
            guard accessToken.trimmingByWhitespacesAndNewLines.count == 32 else {
                throw FormValidationErrors.invalidAccessToken
            }
        }

    }
}
