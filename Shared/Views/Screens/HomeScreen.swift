//
//  HomeScreen.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import SwiftUI
import MetricsLocale

struct HomeScreen: View {
    @EnvironmentObject
    private var namiNavigator: NamiNavigator
    @EnvironmentObject
    private var coreAppManager: CoreAppManager

    @ObservedObject
    private var viewModel = ViewModel()

    var body: some View {
        GeometryReader { (proxy: GeometryProxy) in
            HomeScreenView(
                apps: coreAppManager.apps,
                viewSize: proxy.size,
                addAppAction: addAppAction,
                selectAppAction: onAppPress)
        }
        .onAppear(perform: {
            coreAppManager.fetchAllApps()
        })
        .background(Color.Background)
        #if os(macOS)
        .toolbar(content: {
            Button(action: addAppAction) {
                Label(MetricsLocale.Keys.ADD_APP.localized, systemImage: "plus")
            }
        })
        #endif
    }

    private var viewAlignment: Alignment {
        if coreAppManager.apps.isEmpty {
            return .center
        }
        return .topLeading
    }

    private func onAppPress(_ app: CoreApp) {
        coreAppManager.selectApp(app)
        namiNavigator.navigate(to: .appDetails)
    }

    private func addAppAction() {
        namiNavigator.navigate(to: .addApp)
    }
}

struct HomeScreenView: View {
    let apps: [CoreApp]
    let viewSize: CGSize
    let addAppAction: () -> Void
    let selectAppAction: (_ app: CoreApp) -> Void

    init(
        apps: [CoreApp],
        viewSize: CGSize,
        addAppAction: @escaping () -> Void,
        selectAppAction: @escaping (_ app: CoreApp) -> Void) {
        self.apps = apps
        self.viewSize = viewSize
        self.addAppAction = addAppAction
        self.selectAppAction = selectAppAction
    }

    var body: some View {
        VStack {
            if apps.isEmpty {
                Button(action: addAppAction) {
                    Text(localized: .ADD_APP)
                }
            } else {
                MetricsGridView(
                    headerTitles: [MetricsLocale.Keys.APPS.localized],
                    data: [apps.map(\.renderable)],
                    viewWidth: viewSize.width) { (content: CoreApp.Renderable) -> CoreAppButtonView in
                    let app = apps.first(where: { $0.id == content.id })!
                    return CoreAppButtonView(app: app, action: { selectAppAction(app) })
                }
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
