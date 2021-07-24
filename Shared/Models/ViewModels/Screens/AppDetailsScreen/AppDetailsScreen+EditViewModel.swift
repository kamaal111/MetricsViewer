//
//  AppDetailsScreen+EditViewModel.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 22/07/2021.
//

import SwiftUI
import PersistanceManager
import ConsoleSwift

extension AppDetailsScreen {
    final class EditViewModel: ObservableObject {

        @Published private(set) var editScreenIsActive = false
        @Published private(set) var app: CoreApp?
        @Published var editingAppName = ""
        @Published var editingAppIdentifier = ""
        @Published var editingAccessToken = ""
        @Published var editingSelectedHost: CoreHost?

        private let persistanceManager: PersistanceManager

        init(preview: Bool = false) {
            if preview {
                self.persistanceManager = PersistenceController.preview
            } else {
                self.persistanceManager = PersistenceController.shared
            }
        }

        func onEditPress() -> Result<CoreApp.Args?, AppValidator.Errors> {
            if editScreenIsActive {
                guard let context = persistanceManager.context else {
                    console.error(Date(), "context not found")
                    return .success(nil)
                }
                guard let app = app else {
                    console.error(Date(), "for some reason app is not defined")
                    return .success(nil)
                }

                guard CoreApp.appIdentifierExists(
                    editingAppIdentifier,
                    excluding: app.appIdentifier,
                    context: context) else { return .failure(.appIdentifierNotUnique) }
                let applValidatorResult = AppValidator.validateForm([
                    .appName: editingAppName,
                    .host: editingSelectedHost?.id.uuidString,
                    .accessToken: editingAccessToken
                ])
                switch applValidatorResult {
                case .failure(let failure): return .failure(failure)
                case .success: break
                }
                withAnimation { [weak self] in self?.editScreenIsActive = false }
                let args = CoreApp.Args(
                    name: editingAppName,
                    appIdentifier: editingAppIdentifier,
                    accessToken: editingAccessToken,
                    hostID: editingSelectedHost?.id)
                return .success(args)
            } else {
                if let app = app {
                    editingAppName = app.name
                    editingAccessToken = app.accessToken
                    editingSelectedHost = app.host
                    editingAppIdentifier = app.appIdentifier
                }
                withAnimation { [weak self] in self?.editScreenIsActive = true }
            }
            return .success(nil)
        }

        func setApp(_ app: CoreApp) {
            self.app = app
        }

    }
}
