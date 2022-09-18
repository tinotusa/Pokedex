//
//  ErrorView.swift
//  Pokedex
//
//  Created by Tino on 18/9/2022.
//

import SwiftUI

struct ErrorView: View {
    let text: String
    
    var body: some View {
        VStack {
            Text("Error:")
                .subHeaderStyle()
            Text(text)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .bodyStyle()
        .foregroundColor(.textColour)
        .backgroundColour()
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(text: "Something went wrong.")
    }
}
