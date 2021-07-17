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
        @Published var hostID: UUID?
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

        private let persistenceController: PersistanceManager

        init(preview: Bool = false) {
            if !preview {
                self.persistenceController = PersistenceController.shared
            } else {
                self.persistenceController = PersistenceController.preview
            }
        }

        func onDoneEditing() -> CoreApp? {
            guard let hostID = hostID else {
                // - TODO: LOCALIZE THIS
                alertMessage = AlertMessage(title: "Host is required")
                return nil
            }
            guard let context = persistenceController.context else {
                console.error(Date(), "no context found")
                return nil
            }
            do {
                try Validator.validateForm([
                    .appIdentifier: appIdentifier,
                    .appName: appName,
                    .accessToken: accessToken
                ], context: context)
            } catch {
                if let error = error as? Validator.Errors {
                    alertMessage = error.alertMessage
                    return nil
                }
                console.error(Date(), error.localizedDescription, error)
                return nil
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

// - MARK: - Validator

extension AddAppScreen {
    fileprivate struct Validator {
        private init() { }

        static func validateForm(_ form: [Fields: String], context: NSManagedObjectContext) throws {
            for (key, value) in form {
                try key.validate(value: value, context: context)
            }
        }
    }
}

extension AddAppScreen.Validator {
    fileprivate enum Fields {
        case appName
        case appIdentifier
        case accessToken

        func validate(value: String, context: NSManagedObjectContext) throws {
            switch self {
            case .appName:
                guard !value.trimmingByWhitespacesAndNewLines.isEmpty else {
                    throw Errors.appNameMissing
                }
            case .appIdentifier:
                guard value.trimmingByWhitespacesAndNewLines.split(separator: ".").count > 1 else {
                    throw Errors.invalidAppIdentifier
                }
                let identifiers = try CoreApp.getAllAppIdentifiers(context: context)
                if identifiers.contains(value) {
                    throw Errors.appIdentifierNotUnique
                }
            case .accessToken:
                guard value.trimmingByWhitespacesAndNewLines.count >= 32 else {
                    throw Errors.invalidAccessToken
                }
            }
        }
    }

    fileprivate enum Errors: Error {
        case appNameMissing
        case invalidAppIdentifier
        case invalidAccessToken
        case appIdentifierNotUnique

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
            }
        }
    }
}
