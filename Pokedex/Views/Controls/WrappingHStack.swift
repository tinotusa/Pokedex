//
//  WrappingHStack.swift
//  Pokedex
//
//  Created by Tino on 21/7/2022.
//

import SwiftUI

struct WrappingHStack: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        return proposal.replacingUnspecifiedDimensions()
    }
    
    private func spaces(subviews: Subviews) -> [Double] {
        subviews.indices.map { index in
            guard index < subviews.count - 1 else { return 0.0 }
            return subviews[index].spacing.distance(to: subviews[index + 1].spacing, along: .horizontal)
        }
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }
        
        var location = CGPoint(
            x: bounds.minX,
            y: bounds.midY
        )
        let spaces = spaces(subviews: subviews)
        let maxWidth = bounds.width
        
        for index in subviews.indices {
            let subveiwSize = subviews[index].dimensions(in: proposal)
            
            if location.x + subveiwSize.width / 2 + spaces[index] > maxWidth {
                location.x = bounds.minX
                location.y += subveiwSize.height + spaces[index]
                if index == subviews.count - 1 {
                    location.y += spaces.first!
                }
                print("should be onnew line")
            }
            location.x += subveiwSize.width / 2
            
            subviews[index].place(
                at: location,
                anchor: .center,
                proposal: .unspecified
            )
            
            location.x += subveiwSize.width / 2 + spaces[index]
        }
    }
}
