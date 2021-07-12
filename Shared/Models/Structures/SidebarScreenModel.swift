//
//  SidebarScreenModel.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 12/07/2021.
//

import Foundation
import SwiftUI
import MetricsLocale

struct SidebarScreenModel: Hashable, Identifiable {
    let id: UUID
    let title: String
    let systemImage: String
    let navigationPoint: NamiNavigator.SelectableScreens?

    init(id: UUID, title: String, systemImage: String, navigationPoint: NamiNavigator.SelectableScreens? = nil) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
        self.navigationPoint = navigationPoint
    }

    init(
        id: UUID,
        title: MetricsLocale.Keys,
        systemImage: String,
        navigationPoint: NamiNavigator.SelectableScreens? = nil) {
        self.init(id: id, title: title.localized, systemImage: systemImage, navigationPoint: navigationPoint)
    }

    func view(navigator: NamiNavigator) -> some View {
        Button(action: {
            navigator.navigate(to: navigationPoint)
        }) {
            Label(title, systemImage: systemImage)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
