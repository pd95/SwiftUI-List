//
//  ContentView.swift
//  Shared
//
//  Created by Philipp on 03.09.21.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("selectedTab") var selectedTab = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            MinimalList()
                .tabItem({ Label("Minimal", systemImage: "list.dash") })
                .tag(1)

            BasicList()
                .tabItem({ Label("Basic", systemImage: "list.dash") })
                .tag(2)

            CustomizedList()
                .tabItem({ Label("Custom", systemImage: "list.dash") })
                .tag(3)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
