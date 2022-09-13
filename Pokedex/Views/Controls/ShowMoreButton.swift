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
    let action: () -> Void
    let showButton: Bool
    
    var body: some View {
        HStack {
            Text(LocalizedStringKey(label))
            Spacer()
            if showButton {
                Button(action: action) {
                    HStack {
                        Text(buttonLabel)
                        Image(systemName: "chevron.right")
                    }
                }
            }
        }
    }
}


struct ShowMoreButton_Previews: PreviewProvider {
    static var previews: some View {
        ShowMoreButton(
            label: "Hello w orld",
            action: {},
            showButton: true
        )
    }
}
