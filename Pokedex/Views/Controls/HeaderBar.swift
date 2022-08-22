//
//  HeaderBar.swift
//  Pokedex
//
//  Created by Tino on 19/7/2022.
//

import SwiftUI

struct HeaderBarTitleKey: EnvironmentKey {
    static let defaultValue: String = ""
}

extension EnvironmentValues {
    var headerBarTitle: String {
        get { self[HeaderBarTitleKey.self] }
        set { self[HeaderBarTitleKey.self] = newValue }
    }
}

extension View {
    func setHeaderTitle(_ title: String) -> some View {
        environment(\.headerBarTitle, title)
    }
}

struct HeaderBar<Content: View>: View {
    let content: () -> Content
    @Environment(\.dismiss) private var dismiss
    @Environment(\.headerBarTitle) private var headerBarTitle
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        HStack(spacing: 0) {
            backArrow
            Spacer()
            Text(headerBarTitle)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .center)
                .headerBarTitleStyle()
            Spacer()
            content()
        }
        .bodyStyle()
        .foregroundColor(.textColour)
    }
    
    var backArrow: some View {
        Button {
            dismiss()
        } label: {
            Label("Back", systemImage: "chevron.left")
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
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "person")
                    }
                    Button {
                        
                    } label: {
                        Image(systemName: "heart")
                    }
                }
            }
            .setHeaderTitle("Hello world, this is a long test title.")
        }
    }
}
