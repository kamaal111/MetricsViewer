//
//  ModifyApp+ViewModel.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 22/07/2021.
//

import Foundation
import PersistanceManager
import ConsoleSwift
import CoreData

extension ModifyApp {
    final class ViewModel: ObservableObject {
        @Published var showHostSheet = false
        @Published var editingHostName = ""
        @Published var editingHostURLString = ""
        @Published var selectedHostName: String
        @Published var showAlert = false
        @Published private(set) var alertMessage: AlertMessage? {
            didSet { alertMessageDidSet() }
        }

        private let persistenceController: PersistanceManager

        init(selectedHostName: String, preview: Bool = false) {
            self.selectedHostName = selectedHostName
            if !preview {
                self.persistenceController = PersistenceController.shared
            } else {
                self.persistenceController = PersistenceController.preview
            }
        }

        func onHostSave() -> CoreHost.Args? {
            guard let context = persistenceController.context else {
                console.error(Date(), "no context found")
                return nil
            }
            let validatorResult = HostValidator.validateForm([
                .name: editingHostName,
                .url: editingHostURLString
            ], context: context)
            switch validatorResult {
            case .failure(let failure):
                alertMessage = failure.alertMessage
                return nil
            case .success: break
            }
            // Allready being validated in `HostValidator.validateForm`
            let hostURL = URL(string: editingHostURLString)!
            let args = CoreHost.Args(url: hostURL, name: editingHostName)
            closeHostSheet()
            selectedHostName = editingHostName
            return args
        }

        func onAddHostButtonPress() {
            showHostSheet = true
        }

        func closeHostSheet() {
            showHostSheet = false
            editingHostName = ""
            editingHostURLString = ""
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

// - MARK: - Host Validator

extension ModifyApp {
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

extension ModifyApp.HostValidator {
    fileprivate enum Fields {
        case name
        case url

        func validate(value: String, context: NSManagedObjectContext) -> Result<Void, Errors> {
            switch self {
            case .name:
                if value.trimmingByWhitespacesAndNewLines.isEmpty {
                    return .failure(.nameMissing)
                }
                if CoreHost.findHost(by: .name, of: value, context: context) != nil {
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
            case .nameMissing: return AlertMessage(title: .NAME_MISSING_ALERT_TITLE)
            case .invalidURL: return AlertMessage(title: .INVALID_URL_ALERT_TITLE)
            case .nameNotUnique: return AlertMessage(title: .NAME_NOT_UNIQUE_ALERT_TITLE)
            }
        }
    }
}
