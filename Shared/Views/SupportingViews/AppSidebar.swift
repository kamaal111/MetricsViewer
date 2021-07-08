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

    var body: some View {
        List {
            Section(header: Text(""), content: {
                // - TODO: Create a model with all the needed stuff and put items in a array and loop over them
                Button(action: {
                    namiNavigator.navigate(to: nil)
                }) {
                    Label(MetricsLocale.Keys.HOME.localized, systemImage: "house.fill")
                }
                .buttonStyle(PlainButtonStyle())
                Button(action: {
                    namiNavigator.navigate(to: .addApp)
                }) {
                    Label(MetricsLocale.Keys.ADD_APP.localized, systemImage: "plus")
                }
                .buttonStyle(PlainButtonStyle())
            })
        }
        #if os(macOS)
        .toolbar(content: {
            Button(action: toggleSidebar) {
                // - TODO: Localize this
                Label("Toggle sidebar", systemImage: "sidebar.left")
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
