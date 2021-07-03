//
//  AddAppScreen.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 29/06/2021.
//

import SwiftUI
import SalmonUI

struct AddAppScreen: View {
    var body: some View {
        VStack {
            KFloatingTextField(text: .constant("Hello"), title: "Hello")
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        #if os(macOS)
        // - TODO: LOCALIZE THIS
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
