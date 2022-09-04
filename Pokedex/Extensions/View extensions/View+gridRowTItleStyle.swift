//
//  View+gridRowTItleStyle.swift
//  Pokedex
//
//  Created by Tino on 24/8/2022.
//

import SwiftUI

struct GridRowTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.gray)
            .bodyStyle()
    }
}

extension View {
    func gridRowTitleStyle() -> some View {
        modifier(GridRowTitleStyle())
    }
}
