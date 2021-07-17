//
//  AddAppScreen.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 29/06/2021.
//

import SwiftUI
import SalmonUI
import MetricsUI

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
        VStack {
            KFloatingTextField(text: $viewModel.appName, title: .APP_NAME_FORM_TITLE)
            FloatingTextFieldWithSubtext(
                text: $viewModel.appIdentifier,
                title: .APP_IDENTIFIER_FORM_TITLE,
                subtext: .APP_IDENTIFIER_FORM_SUBTEXT)
            KFloatingTextField(text: $viewModel.accessToken, title: .ACCESS_TOKEN_FORM_TITLE)
            ServiceHostPicker(
                selectedHostName: $viewModel.selectedHostName,
                hostsNames: viewModel.hostsNames,
                serviceHostPickerSubText: viewModel.serviceHostPickerSubText,
                onAddPress: viewModel.onAddHostButtonPress)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .alert(isPresented: $viewModel.showAlert, content: { handledAlert(with: viewModel.alertMessage) })
        .sheet(isPresented: $viewModel.showHostSheet, onDismiss: { print("dismiss add host sheet") }, content: {
            AddHostSheet(
                name: $viewModel.editingHostName,
                urlString: $viewModel.editingHostURLString,
                onSave: viewModel.onHostSave,
                onClose: viewModel.closeHostSheet)
                .alert(isPresented: $viewModel.showAlert, content: { handledAlert(with: viewModel.alertMessage) })
        })
        .onAppear(perform: {
            viewModel.fetchAllHosts()
        })
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
