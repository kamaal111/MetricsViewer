//
//  AddAppScreen+ViewModel.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 03/07/2021.
//

import PersistanceManager
import ConsoleSwift
import CoreData
import MetricsLocale

// - MARK: - View Model

extension AddAppScreen {
    final class ViewModel: ObservableObject {

        @Published var appName = ""
        @Published var appIdentifier = ""
        @Published var accessToken = ""
        @Published var selectedHost: CoreHost? {
            didSet {
                print(selectedHost)
            }
        }
        @Published var showAlert = false
        @Published private(set) var alertMessage: AlertMessage? {
            didSet { alertMessageDidSet() }
        }

        private let persistenceController: PersistanceManager

        init(preview: Bool = false) {
            if !preview {
                self.persistenceController = PersistenceController.shared
            } else {
                self.persistenceController = PersistenceController.preview
            }
        }

        func onDoneEditing() -> CoreApp? {
            guard let context = persistenceController.context else {
                console.error(Date(), "no context found")
                return nil
            }
            let appValidatorResult = AppValidator.validateForm([
                .appIdentifier: appIdentifier,
                .appName: appName,
                .accessToken: accessToken,
                .host: selectedHost?.id.uuidString
            ], context: context)
            switch appValidatorResult {
            case .failure(let failure):
                alertMessage = failure.alertMessage
                return nil
            case .success: break
            }
            let args = CoreApp.Args(
                name: appName,
                appIdentifier: appIdentifier,
                accessToken: accessToken,
                hostID: selectedHost?.id)
            let appResult = CoreApp.setApp(with: args, context: context)
            let app: CoreApp
            switch appResult {
            case .failure(let failure):
                console.error(Date(), failure.localizedDescription, failure)
                return nil
            case .success(let success): app = success
            }
            return app
        }

        private func alertMessageDidSet() {
            if !showAlert && alertMessage != nil {
                showAlert = true
            } else if showAlert && alertMessage == nil {
                showAlert = false
            }
        }

    }
}

// - MARK: - App Validator

extension AddAppScreen {
    fileprivate struct AppValidator {
        private init() { }

        static func validateForm(_ form: [Fields: String?], context: NSManagedObjectContext) -> Result<Void, Errors> {
            for (key, value) in form {
                let result = key.validate(value: value, context: context)
                switch result {
                case .failure(let failure): return .failure(failure)
                case .success: continue
                }
            }
            return .success(Void())
        }
    }
}

extension AddAppScreen.AppValidator {
    fileprivate enum Fields {
        case appName
        case appIdentifier
        case accessToken
        case host

        func validate(value: String?, context: NSManagedObjectContext) -> Result<Void, Errors> {
            switch self {
            case .appName: return validateAppName(value)
            case .appIdentifier: return validateAppIdentifier(value, context: context)
            case .accessToken: return validateAccessToken(value)
            case .host: return validateHost(value)
            }
        }

        private func validateAppName(_ appName: String?) -> Result<Void, Errors> {
            guard let appName = appName else { return .failure(.appNameMissing) }
            if appName.trimmingByWhitespacesAndNewLines.isEmpty {
                return .failure(.appNameMissing)
            }
            return .success(Void())
        }

        private func validateAppIdentifier(
            _ appIdentifier: String?,
            context: NSManagedObjectContext) -> Result<Void, Errors> {
            guard let appIdentifier = appIdentifier else { return .failure(.invalidAppIdentifier) }
            if appIdentifier.trimmingByWhitespacesAndNewLines.split(separator: ".").count < 2 {
                return .failure(.invalidAppIdentifier)
            }
            if CoreApp.appIdentifierExists(appIdentifier, context: context) {
                return .failure(.appIdentifierNotUnique)
            }
            return .success(Void())
        }

        private func validateAccessToken(_ accessToken: String?) -> Result<Void, Errors> {
            guard let accessToken = accessToken else { return .failure(.invalidAccessToken) }
            if accessToken.trimmingByWhitespacesAndNewLines.count < 32 {
                return .failure(.invalidAccessToken)
            }
            return .success(Void())
        }

        private func validateHost(_ host: String?) -> Result<Void, Errors> {
            if host == nil {
                return .failure(.hostIsRequired)
            }
            return .success(Void())
        }
    }

    fileprivate enum Errors: AlertMessageError {
        case appNameMissing
        case invalidAppIdentifier
        case invalidAccessToken
        case appIdentifierNotUnique
        case hostIsRequired

        var alertMessage: AlertMessage {
            switch self {
            case .appNameMissing:
                return AlertMessage(title: .APP_NAME_MISSING_ALERT_TITLE)
            case .invalidAppIdentifier:
                return AlertMessage(title: .INVALID_APP_IDENTIFIER_ALERT_TITLE)
            case .invalidAccessToken:
                return AlertMessage(title: .INVALID_ACCESS_TOKEN_ALERT_TITLE)
            case .appIdentifierNotUnique:
                return AlertMessage(title: .APP_IDENTIFIER_NOT_UNIQUE_ALERT_TITLE)
            case .hostIsRequired:
                return AlertMessage(title: .HOST_IS_REQUIRED_ALERT_TITLE)
            }
        }
    }
}
