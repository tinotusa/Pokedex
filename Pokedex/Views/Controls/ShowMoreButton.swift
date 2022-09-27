//
//  ShowMoreButton.swift
//  Pokedex
//
//  Created by Tino on 13/9/2022.
//

import SwiftUI

struct ShowMoreButton: View {
    var label: String = "List"
    var iconSystemName = "chevron.right"
    
    var body: some View {
        HStack {
            Text(label)
            Image(systemName: iconSystemName)
        }
        .foregroundColor(.blue)
    }
}


struct ShowMoreButton_Previews: PreviewProvider {
    static var previews: some View {
        ShowMoreButton()
    }
}
