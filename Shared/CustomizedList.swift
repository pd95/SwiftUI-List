//
//  CustomizedList.swift
//  CustomizedList
//
//  Created by Philipp on 04.09.21.
//

import SwiftUI

struct CustomizedList: View {

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
    private var rowHeight: CGFloat = 16

    var body: some View {
        List(selection: $selection) {
            Section(header: Text("Top entries").font(.title3),
                    footer: Text("All this gibberish can be ignored, even though it seems to be some latin dialect it is absolute nonsense.")
                        .font(.caption)
            ) {
                ForEach(data) { element in
                    Row(text: element.text, isSelected: selection.contains(element.id))
                }
                .onMove(perform: moveSelection)
                .onDelete(perform: delete)
            }
        }
        .navigationTitle("Customized List")
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

    struct Row: View {
        let text: String
        let isSelected: Bool

        @State private var rowSize: CGSize?

        var body: some View {
            Text(text)
                .fixedSize(horizontal: false, vertical: true)
                .listRowBackground(Group {
                        if isSelected {
                            Color.clear
                        } else {
                            Color.orange
                        }
                    }
                )
                .background(GeometryReader { proxy in
                    let _ = handleSize(proxy.frame(in: .local).size)
                    Color.clear
                })
                .frame(maxHeight: rowSize?.height)
        }

        private func handleSize(_ size: CGSize) {
            print("size", size, text.prefix(5))
            if rowSize != size && size.width != 10 {
                DispatchQueue.main.async {
                    rowSize = size
                }
            }
        }
    }
}

struct CustomizedList_Previews: PreviewProvider {
    static var previews: some View {
        CustomizedList()
    }
}
