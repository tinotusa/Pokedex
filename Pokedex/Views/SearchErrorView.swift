//
//  SearchErrorView.swift
//  Pokedex
//
//  Created by Tino on 9/9/2022.
//

import SwiftUI

struct SearchErrorView: View {
    var text = "Couldn't find anything."
    
    var body: some View {
        VStack {
            Text(text)
                .multilineTextAlignment(.center)
                .bodyStyle()
                .foregroundColor(.textColour)
        }
    }
}

struct SearchErrorView_Previews: PreviewProvider {
    static var previews: some View {
        SearchErrorView()
    }
}
