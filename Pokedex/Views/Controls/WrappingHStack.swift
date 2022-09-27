//
//  WrappingHStack.swift
//  Pokedex
//
//  Created by Tino on 21/7/2022.
//

import SwiftUI

struct WrappingHStack: Layout {
    var spacing = 10.0
    
    init(spacing: Double = 10.0) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let containerWidth = proposal.replacingUnspecifiedDimensions().width
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return layout(sizes: sizes, containerWidth: containerWidth).size
    }
    
    private func layout(sizes: [CGSize], containerWidth: Double) -> (offsets: [CGPoint], size: CGSize) {
        var result = [CGPoint]()
        var currentPosition = CGPoint.zero
        var lineHeight = 0.0
        var maxX = 0.0
        
        for size in sizes {
            if currentPosition.x + size.width > containerWidth {
                currentPosition.x = 0
                currentPosition.y += lineHeight + spacing
                lineHeight = 0
            }
            
            result.append(currentPosition)
            currentPosition.x += size.width
            maxX = max(maxX, currentPosition.x)
            currentPosition.x += spacing
            lineHeight = max(lineHeight, size.height)
        }
        
        return (result, CGSize(width: maxX, height: currentPosition.y + lineHeight))
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let offsets = layout(sizes: sizes, containerWidth: bounds.width).offsets
        for (offset, subview) in zip(offsets, subviews) {
            let location = CGPoint(
                x: offset.x + bounds.minX,
                y: offset.y + bounds.minY
            )
            subview.place(at: location, proposal: .unspecified)
        }
    }
}
