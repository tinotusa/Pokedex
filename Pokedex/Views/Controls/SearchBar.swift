//
//  SearchBar.swift
//  Pokedex
//
//  Created by Tino on 14/7/2022.
//

import SwiftUI

struct SearchBar: View {
    let placeholder: LocalizedStringKey
    @Binding var text: String
    let action: (() -> Void)?
    
    init(placeholder: LocalizedStringKey, text: Binding<String>, action: (() -> Void)? = nil) {
        self.placeholder = placeholder
        _text = text
        self.action = action
    }
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text, prompt: Text(placeholder))
                .autocorrectionDisabled(true)
                .onSubmit {
                    action?()
                }
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .renderingMode(.original)
                }
                .transition(.opacity)
                
            }
            Divider()
                .frame(maxHeight: 30)
            Button {
                action?()
            } label: {
                Image(systemName: "magnifyingglass")
                    .tint(.grayTextColour)
            }
        }
        .animation(.easeInOut, value: text)
        .padding()
        .background(Color.searchBarColour)
        .cornerRadius(14)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(placeholder: "Placeholder", text: .constant(""))
    }
}
