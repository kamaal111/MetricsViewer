//
//  AddAppScreen+ViewModel.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 03/07/2021.
//

import Foundation
import Combine

extension AddAppScreen {
    final class ViewModel: ObservableObject {

        @Published var appName = ""
        @Published var appIdentifier = ""
        @Published var accessToken = ""

    }
}
