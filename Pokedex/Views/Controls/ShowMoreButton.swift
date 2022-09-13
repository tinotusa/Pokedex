//
//  ShowMoreButton.swift
//  Pokedex
//
//  Created by Tino on 13/9/2022.
//

import SwiftUI

struct ShowMoreButton: View {
    let label: String
    var buttonLabel: LocalizedStringKey = "List"
    var iconSystemName = "chevron.right"
    var showButton: Bool = true
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(LocalizedStringKey(label))
            Spacer()
            if showButton {
                Button(action: action) {
                    HStack {
                        Text(buttonLabel)
                        Image(systemName: iconSystemName)
                    }
                }
                .foregroundColor(.blue)
            }
        }
    }
}


struct ShowMoreButton_Previews: PreviewProvider {
    static var previews: some View {
        ShowMoreButton(
            label: "Hello world",
            action: {}
        )
    }
}
