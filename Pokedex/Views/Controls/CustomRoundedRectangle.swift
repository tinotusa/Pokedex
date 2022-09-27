//
//  CustomRoundedRectangle.swift
//  Pokedex
//
//  Created by Tino on 19/7/2022.
//

import SwiftUI

struct CustomRoundedRectangle: Shape {
    let corners: UIRectCorner
    let radius: Double
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
