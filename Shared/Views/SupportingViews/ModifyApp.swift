//
//  ModifyApp.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 21/07/2021.
//

import SwiftUI
import MetricsLocale
import SalmonUI
import MetricsUI
import PersistanceManager
import ConsoleSwift

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
            KFloatingTextField(text: $accessToken, title: .ACCESS_TOKEN_FORM_TITLE)
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
                if let savedHost = viewModel.onHostSave() {
                    coreHostManager.addHost(savedHost)
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

extension ModifyApp {
    final class ViewModel: ObservableObject {
        @Published var showHostSheet = false
        @Published var editingHostName = ""
        @Published var editingHostURLString = ""
        @Published var selectedHostName: String
        @Published var showAlert = false
        @Published private(set) var alertMessage: AlertMessage? {
            didSet { alertMessageDidSet() }
        }

        private let persistenceController: PersistanceManager

        init(selectedHostName: String, preview: Bool = false) {
            self.selectedHostName = selectedHostName
            if !preview {
                self.persistenceController = PersistenceController.shared
            } else {
                self.persistenceController = PersistenceController.preview
            }
        }

        func onHostSave() -> CoreHost? {
            guard let context = persistenceController.context else {
                console.error(Date(), "no context found")
                return nil
            }
            let validatorResult = HostValidator.validateForm([
                .name: editingHostName,
                .url: editingHostURLString
            ], context: context)
            switch validatorResult {
            case .failure(let failure):
                alertMessage = failure.alertMessage
                return nil
            case .success: break
            }
            // Allready being validated in `HostValidator.validateForm`
            let hostURL = URL(string: editingHostURLString)!
            let args = CoreHost.Args(url: hostURL, name: editingHostName)
            // - TODO: Move this to core host manager
            let hostResult = CoreHost.setHost(with: args, context: context)
            let host: CoreHost
            switch hostResult {
            case .failure(let failure):
                console.error(Date(), failure.localizedDescription, failure)
                return nil
            case .success(let success): host = success
            }
            closeHostSheet()
            selectedHostName = host.name
            return host
        }

        func onAddHostButtonPress() {
            showHostSheet = true
        }

        func closeHostSheet() {
            showHostSheet = false
            editingHostName = ""
            editingHostURLString = ""
        }

        private func alertMessageDidSet() {
            if !showAlert && alertMessage != nil {
                showAlert = true
            } else if showAlert && alertMessage == nil {
                showAlert = false
            }
        }
    }
}

// - MARK: - Host Validator

extension ModifyApp {
    fileprivate struct HostValidator {
        private init() { }

        static func validateForm(_ form: [Fields: String], context: NSManagedObjectContext) -> Result<Void, Errors> {
            for (key, value) in form {
                let result = key.validate(value: value, context: context)
                switch result {
                case .failure(let failure): return .failure(failure)
                case .success: continue
                }
            }
            return .success(Void())
        }
    }
}

extension ModifyApp.HostValidator {
    fileprivate enum Fields {
        case name
        case url

        func validate(value: String, context: NSManagedObjectContext) -> Result<Void, Errors> {
            switch self {
            case .name:
                if value.trimmingByWhitespacesAndNewLines.isEmpty {
                    return .failure(.nameMissing)
                }
                if CoreHost.findHost(by: .name, of: value, context: context) != nil {
                    return .failure(.nameNotUnique)
                }
            case .url:
                if value.trimmingByWhitespacesAndNewLines.isEmpty, URL(string: value) == nil {
                    return .failure(.invalidURL)
                }
            }
            return .success(Void())
        }
    }

    fileprivate enum Errors: AlertMessageError {
        case nameMissing
        case nameNotUnique
        case invalidURL

        var alertMessage: AlertMessage {
            switch self {
            case .nameMissing: return AlertMessage(title: .NAME_MISSING_ALERT_TITLE)
            case .invalidURL: return AlertMessage(title: .INVALID_URL_ALERT_TITLE)
            case .nameNotUnique: return AlertMessage(title: .NAME_NOT_UNIQUE_ALERT_TITLE)
            }
        }
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
