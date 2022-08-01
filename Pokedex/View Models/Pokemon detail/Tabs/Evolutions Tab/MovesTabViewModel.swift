//
//  MovesTabViewModel.swift
//  Pokedex
//
//  Created by Tino on 1/8/2022.
//

import Foundation

@MainActor
final class MovesTabViewModel: ObservableObject {
    /// The pokemon that has the moves being listed.
    let pokemon: Pokemon
    /// The moves of the pokemon.
    @Published private(set) var moves = [Move]()
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        Task {
            moves = await getMoves()
        }
    }
    /// Gets the downloads the moves from PokiAPI
    /// - returns: A sorted array of `Move`
    private func getMoves() async -> [Move] {
        var moves = [Move]()
        await withTaskGroup(of: Move?.self) { group in
            for pokemonMove in pokemon.moves {
                group.addTask {
                    let name = pokemonMove.move.name
                    let move = await Move.from(name: name)
                    return move
                }
            }
            for await move in group {
                if let move {
                    moves.append(move)
                }
            }
        }
        return moves.sorted()
    }
}
