//
//  View+CardView.swift
//  Pokedex
//
//  Created by Tino on 11/9/2022.
//

import SwiftUI

struct CardView: ViewModifier {
    var cornerRadius: Double
    var shadowOpacity: Double
    var shadowRadius: Double
    var shadowX: Double
    var shadowY: Double
    
    func body(content: Content) -> some View {
        content
            .background(Color.cardBackgroundColour)
            .cornerRadius(cornerRadius)
            .shadow(
                color: .black.opacity(shadowOpacity),
                radius: shadowRadius,
                x: shadowX,
                y: shadowY
            )
    }
}

extension View {
    func card(
        cornerRadius: Double = 14.0,
        shadowOpacity: Double = 0.2,
        shadowRadius: Double = 2.0,
        shadowX: Double = 0.0,
        shadowY: Double = 2.0
    ) -> some View {
        modifier(
            CardView(
                cornerRadius: cornerRadius,
                shadowOpacity: shadowOpacity,
                shadowRadius: shadowRadius,
                shadowX: shadowX,
                shadowY: shadowY
            )
        )
    }
}
