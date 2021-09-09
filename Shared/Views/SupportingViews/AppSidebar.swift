//
//  AppSidebar.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import SwiftUI
import MetricsLocale

struct AppSidebar: View {
    @EnvironmentObject
    var namiNavigator: NamiNavigator

    private let items: [SidebarScreenModel] = [
        SidebarScreenModel(
            id: UUID(uuidString: "d4a92f62-2b40-4d8b-8041-6146d8524bc9")!,
            title: .HOME,
            systemImage: "house.fill"),
        SidebarScreenModel(
            id: UUID(uuidString: "6cbce375-f34d-4333-ab70-9208d5fc5c75")!,
            title: .ADD_APP,
            systemImage: "plus",
            navigationPoint: .addApp),
        SidebarScreenModel(
            id: UUID(uuidString: "12badbc1-1c11-4285-a095-716f7caa946f")!,
            // - TODO: Localize this
            title: "Edit host",
            systemImage: "network",
            navigationPoint: .editHost)
    ]

    var body: some View {
        List {
            Section(header: Text(""), content: {
                ForEach(items, id: \.id, content: { item in
                    item.view(navigator: namiNavigator)
                })
            })
        }
        #if os(macOS)
        .toolbar(content: {
            Button(action: toggleSidebar) {
                Label(MetricsLocale.Keys.TOGGLE_SIDEBAR.localized, systemImage: "sidebar.left")
            }
        })
        #endif
    }

    #if os(macOS)
    private func toggleSidebar() {
        guard let firstResponder = NSApp.keyWindow?.firstResponder else { return }
        firstResponder.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    #endif
}

struct AppSidebar_Previews: PreviewProvider {
    static var previews: some View {
        AppSidebar()
            .environmentObject(NamiNavigator())
    }
}
