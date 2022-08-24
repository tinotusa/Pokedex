//
//  View+colouredLabel.swift
//  Pokedex
//
//  Created by Tino on 24/8/2022.
//

import SwiftUI

struct ColouredLabel: ViewModifier {
    /// The name of the colour in the assets catalog
    var colourName: String
    
    func body(content: Content) -> some View {
        content
            .tagStyle()
            .padding(.horizontal)
            .padding(.vertical, 3)
            .foregroundColor(.white)
            .background(Color(colourName))
            .cornerRadius(6)
    }
}

extension View {
    /// Makes the label white and gives it a rounded rectangle background
    /// with the given colour from the asset catalog.
    func colouredLabel(colourName: String) -> some View {
        modifier(ColouredLabel(colourName: colourName))
    }
}
