//
//  CoreAppManager.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 07/07/2021.
//

import Foundation
import PersistanceManager
import ConsoleSwift

final class CoreAppManager: ObservableObject {

    @Published private(set) var apps: [CoreApp] = []
    @Published private(set) var selectedApp: CoreApp?

    private let persistenceController: PersistanceManager

    init(preview: Bool = false) {
        if !preview {
            self.persistenceController = PersistenceController.shared
        } else {
            self.persistenceController = PersistenceController.preview
        }
    }

    func selectApp(_ app: CoreApp) {
        selectedApp = app
    }

    func replaceApp(with app: CoreApp) {
        guard let index = apps.firstIndex(where: { $0.id == app.id }) else { return }
        apps[index] = app
    }

    func addApp(_ app: CoreApp) {
        apps.append(app)
    }

    func fetchAllApps() {
        let appsResult = persistenceController.fetch(CoreApp.self)
        let apps: [CoreApp]
        switch appsResult {
        case .failure(let failure):
            console.error(Date(), failure.localizedDescription, failure)
            return
        case .success(let success):
            guard let success = success else { return }
            apps = success
        }
        self.apps = apps
    }

}
