//
//  HomeScreen.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import SwiftUI
import MetricsLocale

struct HomeScreen: View {
    @Environment(\.colorScheme)
    private var colorScheme

    @EnvironmentObject
    private var namiNavigator: NamiNavigator
    @EnvironmentObject
    private var coreAppManager: CoreAppManager

    @ObservedObject
    private var viewModel = ViewModel()

    var body: some View {
        GeometryReader { (proxy: GeometryProxy) in
            HomeScreenView(apps: coreAppManager.apps, viewSize: proxy.size, addAppAction: addAppAction)
        }
        .onAppear(perform: {
            coreAppManager.fetchAllApps()
        })
        .background(backgroundColor)
        #if os(macOS)
        .toolbar(content: {
            Button(action: addAppAction) {
                Label(MetricsLocale.Keys.ADD_APP.localized, systemImage: "plus")
            }
        })
        #endif
    }

    private var backgroundColor: Color {
        switch colorScheme {
        case .dark: return .black
        case .light: return .white
        @unknown default: return .black
        }
    }

    private var viewAlignment: Alignment {
        if coreAppManager.apps.isEmpty {
            return .center
        }
        return .topLeading
    }

    private func addAppAction() {
        namiNavigator.navigate(to: .addApp)
    }
}

struct HomeScreenView: View {
    let apps: [CoreApp]
    let viewSize: CGSize
    let addAppAction: () -> Void

    init(apps: [CoreApp], viewSize: CGSize, addAppAction: @escaping () -> Void) {
        self.apps = apps
        self.viewSize = viewSize
        self.addAppAction = addAppAction
    }

    var body: some View {
        VStack {
            if apps.isEmpty {
                Button(action: addAppAction) {
                    Text(localized: .ADD_APP)
                }
            } else {
                MetricsGridView(
                    // - TODO: Localize this
                    headerTitles: ["Apps"],
                    data: [apps.map(\.renderable)],
                    viewWidth: viewSize.width,
                    isPressable: true,
                    onCellPress: { content in print(content) })
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: viewAlignment)
    }

    private var viewAlignment: Alignment {
        if apps.isEmpty {
            return .center
        }
        return .topLeading
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
            .environmentObject(NamiNavigator())
            .environmentObject(CoreAppManager(preview: true))
    }
}
