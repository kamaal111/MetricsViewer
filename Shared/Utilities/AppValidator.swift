//
//  AppValidator.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 22/07/2021.
//

import Foundation
import CoreData

struct AppValidator {
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

extension AppValidator {
    enum Fields {
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

    enum Errors: AlertMessageError {
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
