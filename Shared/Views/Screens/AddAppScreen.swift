//
//  AddAppScreen.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 29/06/2021.
//

import SwiftUI

struct AddAppScreen: View {
    @EnvironmentObject
    private var namiNavigator: NamiNavigator
    @EnvironmentObject
    private var coreAppManager: CoreAppManager

    @ObservedObject
    private var viewModel: ViewModel

    init(preview: Bool = false) {
        self.viewModel = ViewModel(preview: preview)
    }

    var body: some View {
        ModifyApp(
            appName: $viewModel.appName,
            appIdentifier: $viewModel.appIdentifier,
            accessToken: $viewModel.accessToken,
            selectedHost: $viewModel.selectedHost)
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .alert(isPresented: $viewModel.showAlert, content: { handledAlert(with: viewModel.alertMessage) })
        #if os(macOS)
        .navigationTitle(Text(localized: .ADD_APP))
        .toolbar(content: {
            Button(action: onDonePress) {
                Text(localized: .DONE)
            }
        })
        #endif
    }

    private func onDonePress() {
        guard let savedApp = viewModel.onDoneEditing() else { return }
        namiNavigator.navigate(to: nil)
        coreAppManager.addApp(savedApp)
    }
}

struct AddAppScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddAppScreen(preview: true)
    }
}
