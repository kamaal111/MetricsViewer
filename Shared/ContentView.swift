//
//  ContentView.swift
//  Shared
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello World!")
            .frame(minWidth: 305, minHeight: 305)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
