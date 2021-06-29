//
//  AddAppScreen.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 29/06/2021.
//

import SwiftUI

struct AddAppScreen: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        #if os(macOS)
        .navigationTitle(Text("Add App"))
        .toolbar(content: {
            Button(action: {
                print("done")
            }) {
                Text("Done")
            }
        })
        #endif
    }
}

struct AddAppScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddAppScreen()
    }
}
