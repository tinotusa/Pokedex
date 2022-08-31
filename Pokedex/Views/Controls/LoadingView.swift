//
//  LoadingView.swift
//  Pokedex
//
//  Created by Tino on 31/8/2022.
//

import SwiftUI

struct LoadingView: View {
    var text: LocalizedStringKey = "Loading"
    
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
            Text(text)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .bodyStyle()
        .foregroundColor(.textColour)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
