//
//  PageView.swift
//  Pokedex
//
//  Created by Tino on 5/9/2022.
//

import SwiftUI

struct PageView<Page: View>: View {
    var pages: [Page]
    @State private var currentPage = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            PageViewController(pages: pages, currentPage: $currentPage)
            
            Text("\(currentPage + 1)/\(pages.count)")
                .foregroundColor(.gray)
                .footerStyle()
                .padding(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .bodyStyle()
        .foregroundColor(.textColour)
    }
}

private extension PageView {
    func scrollIndicatorIcon(systemName: String) -> some View {
        Image(systemName: systemName)
            .footerStyle()
            .foregroundColor(.textColour)
    }
}

struct PageView_Previews: PreviewProvider {
    static var evolutionDetails: [EvolutionDetail] {
        try! Bundle.main.loadJSON(ofType: EvolutionChain.self, filename: "evolutionChain", extension: "json")
            .chain.evolvesTo[5].evolutionDetails!
    }
    
    static var previews: some View {
        PageView(
            pages: evolutionDetails.map( { evolutionDetail in
                EvolutionDetailRow(evolutionDetail: evolutionDetail)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .backgroundColour()
            })
        )
        .environmentObject(ImageCache())
    }
}
