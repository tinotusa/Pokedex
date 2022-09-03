//
//  PokemonMovesTabViewModel.swift
//  Pokedex
//
//  Created by Tino on 1/8/2022.
//

import Foundation

@MainActor
final class PokemonMovesTabViewModel: ObservableObject {
    /// The pokemon that has the moves being listed.
    var pokemon: Pokemon?
    /// The moves of the pokemon.
    @Published private(set) var moves = [Move]()
    @Published var viewHasAppeared = false // TODO: should i make this private set and set it in the loadData func
    @Published private(set) var hasNextPage = true
    @Published private(set) var isLoading = false
    
    private var page = 0 {
        didSet {
            offset = page * limit
        }
    }
    private let limit = 10
    private var offset = 0
}


extension PokemonMovesTabViewModel {
    func setUp(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    func getMoves() async {
        guard let pokemon else { return }
        
        isLoading = true
        defer { isLoading = false }
        
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
        }
    }
    
    func getNextMoves() async {
        guard let pokemon else { return }
        print("getNextMoves: offest: \(offset) page: \(page) isLoading: \(isLoading)")
        isLoading = true
        defer { isLoading = false }
        await withTaskGroup(of: Move?.self) { group in
//            if offset > pokemon.moves.count { return }
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
    
    func loadData() async {
        await getMoves()
    }
}
