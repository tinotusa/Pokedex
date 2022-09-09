//
//  LoadingView.swift
//  Pokedex
//
//  Created by Tino on 31/8/2022.
//

import SwiftUI

struct LoadingView: View {
    var text: LocalizedStringKey = "Loading"
    var spinnerImage: String? = nil
    @State private var isSpinning = false
    
    var body: some View {
        VStack {
            Image(spinnerImage ?? "pokeball")
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: Constants.imageSize, height: Constants.imageSize)
                .rotationEffect(.degrees(isSpinning ? 360 : 0))
            Text(text)
                .multilineTextAlignment(.center)
        }
        .bodyStyle()
        .foregroundColor(.textColour)
        .task {
            withAnimation(Animation.linear(duration: 0.8).repeatForever(autoreverses: false)) {
                isSpinning = true
            }
        }
    }
}

private extension LoadingView {
    enum Constants {
        static let imageSize = 25.0
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(text: "Loading something.")
    }
}
