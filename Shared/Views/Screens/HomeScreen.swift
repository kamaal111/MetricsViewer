//
//  HomeScreen.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import SwiftUI
import Combine
import ShrimpExtensions
import XiphiasNet

struct HomeScreen: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        .onAppear(perform: {
            let api = API()
            api.getRoot()
        })
    }
}

class API {
    var subscriptions = Set<AnyCancellable>()
    var response: RootResponse? {
        didSet {
            guard let response = response else { return }
            print(response)
        }
    }
    let networker = XiphiasNet()

    func getRoot() {
        let url = URL(staticString: "http://127.0.0.1:8080")
        let urlRequest = URLRequest(url: url)
        networker.requestPublisher(from: urlRequest)
            .receive(on: DispatchQueue.global(), options: nil)
            .sink(receiveCompletion: { (completion: Subscribers.Completion<Error>) in
                print(completion)
            }, receiveValue: { (response: RootResponse?) in
                self.response = response
            })
            .store(in: &subscriptions)
    }
}

struct RootResponse: Codable {
    let hello: String
    let message: String
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
