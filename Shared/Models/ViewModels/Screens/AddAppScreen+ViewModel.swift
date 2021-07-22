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
        @Published var selectedHost: CoreHost?
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
            // - TODO: MOVE THIS TO MANAGER
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
