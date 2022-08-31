//
//  PopoverNavigationBar.swift
//  Pokedex
//
//  Created by Tino on 31/8/2022.
//

import SwiftUI

struct PopoverNavigationBar: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Label("Close", systemImage: "xmark")
            }
            Spacer()
        }
    }
}

struct PopoverNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        PopoverNavigationBar()
    }
}
