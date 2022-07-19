//
//  HeaderBar.swift
//  Pokedex
//
//  Created by Tino on 19/7/2022.
//

import SwiftUI

struct HeaderBar<Content: View>: View {
    let action: (() -> Void)?
    let content: () -> Content
    
    init(action: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.action = action
        self.content = content
    }
    
    var body: some View {
        HStack {
            backArrow
            Spacer()
            content()
        }
        .font(.title)
        .foregroundColor(.textColour)
    }
    
    var backArrow: some View {
        Button {
            action?()
        } label: {
            Image(systemName: "arrow.left")
        }
    }
}

struct HeaderBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .fill(Color.blue.gradient)
                .ignoresSafeArea()
            HeaderBar {
                // dismiss action
            } content: {
                
            }
        }
    }
}
