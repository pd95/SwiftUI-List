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
                .wrappedInNavigationView()
                .tabItem({ Label("Minimal", systemImage: "list.dash") })
                .tag(1)

            BasicList()
                .environment(\.editMode, .constant(.active))
                .wrappedInNavigationView()
                .tabItem({ Label("Basic", systemImage: "list.dash") })
                .tag(2)

            CustomizedList()
                .environment(\.editMode, .constant(.active))
                .wrappedInNavigationView()
                .tabItem({ Label("Custom", systemImage: "list.dash") })
                .tag(3)
        }
    }
}

extension View {
    func wrappedInNavigationView() -> some View{
        NavigationView {
            self
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
