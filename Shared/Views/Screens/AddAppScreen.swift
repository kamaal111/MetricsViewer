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
            VStack {
                HStack {
                    // - TODO: LOCALIZE THIS
                    Picker("Service host", selection: $viewModel.selectedHostName) {
                        ForEach(viewModel.hostsNames, id: \.self) { name in
                            Text(name)
                                .tag(name)
                        }
                    }
                    Button(action: viewModel.onAddHostButtonPress) {
                        Image(systemName: "plus")
                    }
                }
                if let serviceHostPickerSubText = viewModel.serviceHostPickerSubText {
                    Text(serviceHostPickerSubText)
                        .foregroundColor(.secondary)
                        .font(.footnote)
                        .padding(.top, -8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.vertical, 12)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .alert(isPresented: $viewModel.showAlert, content: { handledAlert(with: viewModel.alertMessage) })
        .sheet(isPresented: $viewModel.showHostSheet, onDismiss: { print("dismiss") }, content: {
            // - TODO: LOCALIZE THIS
            KSheetStack(title: "Add service host", leadingNavigationButton: {
                Button(action: {
                    print("save")
                }) {
                    // - TODO: LOCALIZE THIS
                    Text("Save")
                }
            }, trailingNavigationButton: {
                Button(action: viewModel.closeHostSheet) {
                    // - TODO: LOCALIZE THIS
                    Text("Close")
                }
            }) {
                Text("Hi")
            }
            .frame(minWidth: 400)
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
