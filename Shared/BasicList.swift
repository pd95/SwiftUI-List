//
//  BasicList.swift
//  BasicList
//
//  Created by Philipp on 03.09.21.
//

import SwiftUI

struct BasicList: View {

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
        List(selection: $selection) {
            Section(header: Text("Top entries").font(.title3),
                    footer: Text("All this gibberish can be ignored, even though it seems to be some latin dialect it is absolute nonsense.")
                        .font(.caption)
            ) {
                ForEach(data) { element in
                    Text(element.text)
                        .listRowBackground(Group {
                            if selection.contains(element.id){
                                Color.clear
                            } else {
                                Color.orange
                            }
                        })
                }
                .onMove(perform: moveSelection)
                .onDelete(perform: delete)
            }
        }
        .navigationTitle("Basic List")
    }

    func delete(_ indices: IndexSet) {
        withAnimation {
            data.remove(atOffsets: indices)
        }
    }

    func moveSelection(_ indices: IndexSet, to offset: Int) {
        withAnimation {
            data.move(fromOffsets: indices, toOffset: offset)
        }
    }
}

struct BasicList_Previews: PreviewProvider {
    static var previews: some View {
        BasicList()
    }
}
