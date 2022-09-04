//
//  View+BackgroundColour.swift
//  Pokedex
//
//  Created by Tino on 4/9/2022.
//

import SwiftUI

struct BackgroundColour: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                Color.backgroundColour
                    .ignoresSafeArea()
            }
    }
}

extension View {
    func backgroundColour() -> some View {
        self.modifier(BackgroundColour())
    }
}
