//
//  HomeScreen+ViewModel.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import Foundation
import MetricsNetworker
import Combine
import XiphiasNet

extension HomeScreen {
    final class ViewModel: ObservableObject {

        @Published var root: RootResponse? {
            didSet {
                guard let root = root else { return }
                print(root)
            }
        }

        private let networkController = NetworkController.shared

        func getRoot() {
            networkController.getRoot(completion: { (result: Result<RootResponse?, XiphiasNet.Errors>) in
                switch result {
                case .failure(let failure): print(failure)
                case .success(let success):
                    guard let success = success else { return }
                    DispatchQueue.main.async { [weak self] in
                        self?.root = success
                    }
                }
            })
        }

        func addApp() {
            print("add")
        }

    }
}
