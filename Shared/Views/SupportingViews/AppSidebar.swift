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
                NavigationLink(destination: HomeScreen(), tag: .home, selection: $namiNavigator.selectedScreen) {
                    Label(MetricsLocale.Keys.HOME.localized, systemImage: "house.fill")
                }
                NavigationLink(destination: AddAppScreen(), tag: .addApp, selection: $namiNavigator.selectedScreen) {
                    Label(MetricsLocale.Keys.ADD_APP.localized, systemImage: "plus")
                }
            })
        }
    }
}

struct AppSidebar_Previews: PreviewProvider {
    static var previews: some View {
        AppSidebar()
            .environmentObject(NamiNavigator())
    }
}
