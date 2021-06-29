//
//  NamiNavigator.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 29/06/2021.
//

import Foundation
import Combine

final class NamiNavigator: ObservableObject {

    @Published var selectedScreen: SelectableScreens?

    enum SelectableScreens {
        case home
        case addApp
    }

    func navigate(to screen: SelectableScreens) {
        DispatchQueue.main.async { [weak self] in
            self?.selectedScreen = screen
        }
    }

}
