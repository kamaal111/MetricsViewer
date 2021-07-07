//
//  CoreAppManager.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 07/07/2021.
//

import Foundation
import PersistanceManager
import ConsoleSwift

final class CoreaAppManager: ObservableObject {

    @Published private(set) var apps: [CoreApp] = []

    private let persistenceController: PersistanceManager

    init(preview: Bool = false) {
        if !preview {
            self.persistenceController = PersistenceController.shared
        } else {
            self.persistenceController = PersistenceController.preview
        }
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
