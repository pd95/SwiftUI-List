//
//  SizePreferenceKey.swift
//  SizePreferenceKey
//
//  Created by Philipp on 04.09.21.
//

import SwiftUI

// Shamelessly inspired by FiveStars article on reading the view size:
// https://www.fivestars.blog/articles/swiftui-share-layout-information/

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        self.background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}
