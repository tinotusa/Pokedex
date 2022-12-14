//
//  PokemonMovesTabViewModel.swift
//  Pokedex
//
//  Created by Tino on 1/8/2022.
//

import Foundation

@MainActor
final class PokemonMovesTabViewModel: ObservableObject {
    private var pokemon: Pokemon?
    @Published private(set) var moves = [Move]()
    @Published private(set) var viewState = ViewState.loading
    @Published private(set) var hasNextPage = true
    
    private var page = 0 {
        didSet {
            offset = page * limit
        }
    }
    private let limit = 10
    private var offset = 0
}


extension PokemonMovesTabViewModel {
    private func setUp(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    func getMoves(pokemon: Pokemon) async {
        setUp(pokemon: pokemon)
        
        await withTaskGroup(of: Move?.self) { group in
            for (i, pokemonMove) in pokemon.moves.enumerated() where i < limit {
                group.addTask {
                    let name = pokemonMove.move.name
                    let move = try? await Move.from(name: name)
                    return move
                }
            }
            
            var tempMoves = [Move]()
            for await move in group {
                if let move {
                    tempMoves.append(move)
                }
            }
        
            if tempMoves.count < limit {
                hasNextPage = false
            }
            moves = tempMoves
            page += 1
            viewState = .loaded
        }
    }
    
    func getNextMoves() async {
        guard let pokemon else { return }
        await withTaskGroup(of: Move?.self) { group in
            for i in offset ..< pokemon.moves.count where i < offset + limit {
                group.addTask {
                    let pokemonMove = pokemon.moves[i]
                    print("getNextMoves: offest i: \(i)")
                    let name = pokemonMove.move.name
                    do {
                        let move = try await Move.from(name: name)
                        return move
                    } catch {
                        print("getNextMoves: \(name) \(error)")
                    }
                    return nil
                }
            }
            
            var tempMoves = [Move]()
            for await move in group {
                if let move {
                    tempMoves.append(move)
                } else {
                    print("getNextMoves: move is nil")
                }
            }
            if tempMoves.count < limit {
                print("getNextMoves: limit reached count: \(tempMoves.count) offset: \(offset) page: \(page)")
                hasNextPage = false
            }
            moves.append(contentsOf: tempMoves)
            page += 1
        }
    }

    var sortedMoves: [Move] {
        moves.sorted()
    }
}
