//
//  BasicList.swift
//  BasicList
//
//  Created by Philipp on 03.09.21.
//

import SwiftUI

struct MinimalList: View {

    struct DataWrapper: Identifiable {
        let id = UUID()
        var text: String
    }

    @State private var data = [
        "Lorem ipsum dolor sit amet, consetetur sadipscing",
        "elitr, sed diam nonumy eirmod tempor invidunt ut",
        "labore et dolore magna aliquyam erat, sed diam",
        "voluptua. At vero eos et accusam et justo duo",
        "dolores et ea rebum. Stet clita kasd gubergren,",
        "no sea takimata sanctus est Lorem ipsum dolor sit amet.",
        "Lorem ipsum dolor sit amet, consetetur sadipscing elitr,",
        "sed diam nonumy eirmod tempor invidunt ut labore",
        "et dolore magna aliquyam erat, sed diam voluptua.",
        "At vero eos et accusam et justo duo dolores",
        "et ea rebum. Stet clita kasd gubergren, no sea",
        "takimata sanctus est Lorem ipsum dolor sit amet.",
    ].map(DataWrapper.init)

    @State private var selection = Set<UUID>()

    var body: some View {
        List(data) { element in
            Text(element.text)
        }
        .navigationTitle("Minimal List")
    }
}

struct MinimalList_Previews: PreviewProvider {
    static var previews: some View {
        MinimalList()
    }
}
