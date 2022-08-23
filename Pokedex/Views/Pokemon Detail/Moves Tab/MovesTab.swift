//
//  MovesTab.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

struct MovesTab: View {
    @StateObject private var viewModel: MovesTabViewModel
    
    init(pokemon: Pokemon) {
        _viewModel = StateObject(wrappedValue: MovesTabViewModel(pokemon: pokemon))
    }
    
    private let columns: [GridItem] = [
        .init(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.moves) { move in
                    NavigationLink(value: move) {
                        MoveGridItemView(move: move)
                    }
                }
            }
        }
        .navigationDestination(for: Move.self) { move in
            Text("Move detail view here.\(move.name)")
        }
    }
}

struct MovesTab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MovesTab(pokemon: .example)
        }
    }
}
