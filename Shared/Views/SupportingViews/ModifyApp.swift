//
//  ModifyApp.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 21/07/2021.
//

import SwiftUI
import SalmonUI
import MetricsUI

struct ModifyApp: View {
    @EnvironmentObject
    private var coreHostManager: CoreHostManager

    @ObservedObject
    private var viewModel: ViewModel

    @Binding var appName: String
    @Binding var appIdentifier: String
    @Binding var accessToken: String
    @Binding var selectedHost: CoreHost?

    init(
        appName: Binding<String>,
        appIdentifier: Binding<String>,
        accessToken: Binding<String>,
        selectedHost: Binding<CoreHost?>,
        preview: Bool = false) {
        self._appName = appName
        self._appIdentifier = appIdentifier
        self._accessToken = accessToken
        self._selectedHost = selectedHost
        let selectedHostName = selectedHost.wrappedValue?.name ?? ""
        self.viewModel = ViewModel(selectedHostName: selectedHostName, preview: preview)
    }

    var body: some View {
        VStack {
            KFloatingTextField(text: $appName, title: .APP_NAME_FORM_TITLE)
            FloatingTextFieldWithSubtext(
                text: $appIdentifier,
                title: .APP_IDENTIFIER_FORM_TITLE,
                subtext: .APP_IDENTIFIER_FORM_SUBTEXT)
            SecureFloatingField(text: $accessToken, title: .ACCESS_TOKEN_FORM_TITLE)
            ServiceHostPicker(
                selectedHostName: $viewModel.selectedHostName,
                hostsNames: coreHostManager.hosts.map(\.name),
                onAddPress: viewModel.onAddHostButtonPress)
        }
        .onAppear(perform: {
            coreHostManager.fetchAllHosts()
        })
        .sheet(isPresented: $viewModel.showHostSheet, onDismiss: { print("dismiss add host sheet") }, content: {
            AddHostSheet(
                name: $viewModel.editingHostName,
                urlString: $viewModel.editingHostURLString,
                onSave: {
                if let hostArgs = viewModel.onHostSave(), let savedHost = coreHostManager.saveHost(hostArgs) {
                    selectedHost = savedHost
                }
            },
                onClose: viewModel.closeHostSheet)
                .alert(isPresented: $viewModel.showAlert, content: { handledAlert(with: viewModel.alertMessage) })
        })
        .onChange(of: viewModel.selectedHostName, perform: { newValue in
            guard !newValue.trimmingByWhitespacesAndNewLines.isEmpty,
                    let selectedHost = coreHostManager.hosts.first(where: { $0.name == newValue }) else { return }
            self.selectedHost = selectedHost
        })
    }
}

struct ModifyApp_Previews: PreviewProvider {
    static var previews: some View {
        ModifyApp(
            appName: .constant("Name"),
            appIdentifier: .constant("app.identifier.yes"),
            accessToken: .constant("super-save-token"),
            selectedHost: .constant(nil))
    }
}
