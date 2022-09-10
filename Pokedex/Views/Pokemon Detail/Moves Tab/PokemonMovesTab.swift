//
//  PokemonMovesTab.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

struct PokemonMovesTab: View {
    let pokemon: Pokemon
    @StateObject private var viewModel = PokemonMovesTabViewModel()
    
    private let columns: [GridItem] = [
        .init(.adaptive(minimum: 350))
    ]
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                LoadingView()
                    .task {
                        await viewModel.getMoves(pokemon: pokemon)
                    }
            case .loaded:
                movesList
            default:
                Text("Error view not possible")
            }
        }
    }
}

private extension PokemonMovesTab {
    var movesList: some View {
        LazyVGrid(columns: columns) {
            ForEach(viewModel.sortedMoves) { move in
                NavigationLink(value: move) {
                    MoveCard(move: move)
                }
            }
            if viewModel.hasNextPage {
                ProgressView()
                    .task {
                        await viewModel.getNextMoves()
                    }
            }
        }
    }
}

struct PokemonMovesTab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PokemonMovesTab(pokemon: .example)
        }
    }
}
