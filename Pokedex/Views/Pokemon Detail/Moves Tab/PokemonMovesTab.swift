//
//  PokemonMovesTab.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

struct PokemonMovesTab: View {
    @State var pokemon: Pokemon
    @StateObject private var viewModel = PokemonMovesTabViewModel()
    
    private let columns: [GridItem] = [
        .init(.adaptive(minimum: 350))
    ]
    
    var body: some View {
        Group {
            if !viewModel.viewHasAppeared {
                LoadingView()
            } else {
                movesList
            }
        }
        .task {
            if !viewModel.viewHasAppeared {
                viewModel.setUp(pokemon: pokemon)
                await viewModel.loadData()
                viewModel.viewHasAppeared = true
            }
        }
//        .navigationDestination(for: Move.self) { move in
//            Text("Move detail view here.\(move.name)")
//        }
    }
}

private extension PokemonMovesTab {
    var movesList: some View {
        LazyVGrid(columns: columns) {
            ForEach(viewModel.moves) { move in
                NavigationLink {
                    MoveDetail(move: move)
                } label: {
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
