//
//  AddAppScreen+ViewModel.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 03/07/2021.
//

import Foundation
import Combine
import ShrimpExtensions

// - MARK: - View Model

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

        func onDoneEditing() {
            do {
                try Validator.validateForm([
                    .appIdentifier: appIdentifier,
                    .appName: appName,
                    .accessToken: accessToken
                ])
            } catch {
                if let error = error as? Validator.Errors {
                    alertMessage = error.alertMessage
                }
                return
            }
            print("done")
        }

    }
}

// - MARK: - Validator

extension AddAppScreen {
    fileprivate struct Validator {
        private init() { }

        static func validateForm(_ form: [Fields: String]) throws {
            for field in form {
                try field.key.validate(value: field.value)
            }
        }
    }
}

extension AddAppScreen.Validator {
    fileprivate enum Fields {
        case appName
        case appIdentifier
        case accessToken

        func validate(value: String) throws {
            switch self {
            case .appName:
                guard !value.trimmingByWhitespacesAndNewLines.isEmpty else {
                    throw Errors.appNameMissing
                }
            case .appIdentifier:
                guard value.trimmingByWhitespacesAndNewLines.split(separator: ".").count > 1 else {
                    throw Errors.invalidAppIdentifier
                }
            case .accessToken:
                guard value.trimmingByWhitespacesAndNewLines.count == 32 else {
                    throw Errors.invalidAccessToken
                }
            }
        }
    }

    fileprivate enum Errors: Error {
        case appNameMissing
        case invalidAppIdentifier
        case invalidAccessToken
        case general

        var alertMessage: AlertMessage {
            switch self {
            case .appNameMissing:
                // - TODO: LOCALIZE THIS
                return AlertMessage(title: "App name is missing")
            case .invalidAppIdentifier:
                // - TODO: LOCALIZE THIS
                return AlertMessage(title: "Invalid app identifier")
            case .invalidAccessToken:
                // - TODO: LOCALIZE THIS
                return AlertMessage(title: "Invalid access token")
            case .general:
                // - TODO: LOCALIZE THIS
                return AlertMessage(title: "Something went wrong")
            }
        }
    }
}
