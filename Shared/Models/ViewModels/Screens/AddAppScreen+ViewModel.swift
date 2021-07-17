//
//  AddAppScreen+ViewModel.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 03/07/2021.
//

import Foundation
import Combine
import ShrimpExtensions
import PersistanceManager
import ConsoleSwift
import CoreData

// - MARK: - View Model

extension AddAppScreen {
    final class ViewModel: ObservableObject {

        @Published var appName = ""
        @Published var appIdentifier = ""
        @Published var accessToken = ""
        @Published private(set) var hostID: UUID?
        @Published var selectedHostName = ""
        @Published var editingHostName = ""
        @Published var editingHostURLString = ""
        @Published var showHostSheet = false
        @Published var showAlert = false
        @Published private(set) var hosts: [CoreHost] = []
        @Published private(set) var alertMessage: AlertMessage? {
            didSet {
                // - TODO: PUT THIS IN A FUNCTION
                if !showAlert && alertMessage != nil {
                    showAlert = true
                } else if showAlert && alertMessage == nil {
                    showAlert = false
                }
            }
        }

        private let persistenceController: PersistanceManager

        init(preview: Bool = false) {
            if !preview {
                self.persistenceController = PersistenceController.shared
            } else {
                self.persistenceController = PersistenceController.preview
            }
        }

        var serviceHostPickerSubText: String? {
            if hostsNames.isEmpty {
                // - TODO: LOCALIZE THIS
                return "No service hosts saved previously, press the plus to add an service host"
            }
            return nil
        }

        var hostsNames: [String] {
            hosts.map(\.name)
        }

        func onAddHostButtonPress() {
            showHostSheet = true
        }

        func closeHostSheet() {
            showHostSheet = false
            editingHostName = ""
            editingHostURLString = ""
        }

        func onHostSave() {
            guard let context = persistenceController.context else {
                console.error(Date(), "no context found")
                return
            }
            let validatorResult = HostValidator.validateForm([
                .name: editingHostName,
                .url: editingHostURLString
            ], context: context)
            switch validatorResult {
            case .failure(let failure):
                alertMessage = failure.alertMessage
                return
            case .success: break
            }
            // Allready being validated in `HostValidator.validateForm`
            let hostURL = URL(string: editingHostURLString)!
            let args = CoreHost.Args(url: hostURL, name: editingHostName)
            let hostResult = CoreHost.setHost(with: args, context: context)
            let host: CoreHost
            switch hostResult {
            case .failure(let failure):
                console.error(Date(), failure.localizedDescription, failure)
                return
            case .success(let success): host = success
            }
            closeHostSheet()
            hosts = hosts.appended(host)
            selectedHostName = host.name
        }

        func fetchAllHosts() {
            let hostsResult = persistenceController.fetch(CoreHost.self)
            let hosts: [CoreHost]
            switch hostsResult {
            case .failure(let failure):
                console.error(Date(), failure.localizedDescription, failure)
                return
            case .success(let success): hosts = success ?? []
            }
            self.hosts = hosts
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
                .host: hostID?.uuidString
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
                hostID: hostID)
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

    }
}

// - MARK: - Host Validator

extension AddAppScreen {
    fileprivate struct HostValidator {
        private init() { }

        static func validateForm(_ form: [Fields: String], context: NSManagedObjectContext) -> Result<Void, Errors> {
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

extension AddAppScreen.HostValidator {
    fileprivate enum Fields {
        case name
        case url

        func validate(value: String, context: NSManagedObjectContext) -> Result<Void, Errors> {
            switch self {
            case .name:
                if value.trimmingByWhitespacesAndNewLines.isEmpty {
                    return .failure(.nameMissing)
                }
                if CoreHost.findHost(byName: value, context: context) != nil {
                    return .failure(.nameNotUnique)
                }
            case .url:
                if value.trimmingByWhitespacesAndNewLines.isEmpty, URL(string: value) == nil {
                    return .failure(.invalidURL)
                }
            }
            return .success(Void())
        }
    }

    fileprivate enum Errors: AlertMessageError {
        case nameMissing
        case nameNotUnique
        case invalidURL

        var alertMessage: AlertMessage {
            switch self {
                // - TODO: LOCALIZE THIS
            case .nameMissing: return AlertMessage(title: "Name is missing")
                // - TODO: LOCALIZE THIS
            case .invalidURL: return AlertMessage(title: "Invalid url provided")
                // - TODO: LOCALIZE THIS
            case .nameNotUnique: return AlertMessage(title: "Name should be unique")
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
            let identifiers: [String]
            do {
                identifiers = try CoreApp.getAllAppIdentifiers(context: context)
            } catch {
                console.error(Date(), error.localizedDescription, error)
                return .failure(.invalidAppIdentifier)
            }
            if identifiers.contains(appIdentifier) {
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
                // - TODO: LOCALIZE THIS
                return AlertMessage(title: "Host is required")
            }
        }
    }
}
