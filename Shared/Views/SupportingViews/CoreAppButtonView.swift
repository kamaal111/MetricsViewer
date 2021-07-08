//
//  CoreAppButtonView.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 08/07/2021.
//

import SwiftUI

struct CoreAppButtonView: View {
    let app: CoreApp

    var body: some View {
        Button(action: {
            print(app)
        }) {
            Text(app.name)
                .font(.title3)
                .bold()
                .foregroundColor(.accentColor)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CoreAppButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            if let app = try? PersistenceController.preview.fetch(CoreApp.self).get()?.first {
                CoreAppButtonView(app: app)
            } else {
                Text("Preview for core app not configured")
            }
        }
    }
}
