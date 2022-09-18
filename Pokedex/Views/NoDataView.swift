//
//  NoDataView.swift
//  Pokedex
//
//  Created by Tino on 18/9/2022.
//

import SwiftUI

struct NoDataView: View {
    let text: String
    
    var body: some View {
        VStack {
            Text(text)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .bodyStyle()
        .foregroundColor(.textColour)
        .backgroundColour()
    }
}

struct NoDataView_Previews: PreviewProvider {
    static var previews: some View {
        NoDataView(text: "No data to load.")
    }
}
