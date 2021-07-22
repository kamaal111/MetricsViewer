//
//  AppDetailsScreen+EditViewModel.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 22/07/2021.
//

import SwiftUI

extension AppDetailsScreen {
    final class EditViewModel: ObservableObject {

        @Published private(set) var editScreenIsActive = false {
            didSet {
                guard editScreenIsActive else { return }
            }
        }
        @Published private(set) var app: CoreApp?
        @Published var editingAppName = ""
        @Published var editingAppIdentifier = ""
        @Published var editingAccessToken = ""
        @Published var editingSelectedHost: CoreHost?

        func onEditPress() {
            if editScreenIsActive {
                withAnimation { [weak self] in self?.editScreenIsActive = false }
            } else {
                if let app = app {
                    editingAppName = app.name
                    editingAccessToken = app.accessToken
                    editingSelectedHost = app.host
                    editingAppIdentifier = app.appIdentifier
                }
                withAnimation { [weak self] in self?.editScreenIsActive = true }
            }
        }

        func setApp(_ app: CoreApp) {
            self.app = app
        }

    }
}
