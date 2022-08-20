//
//  MoveGridViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 20/8/2022.
//

import SwiftUI

@MainActor
final class MoveGridViewViewModel: ObservableObject {
    @Published var moves = Set<Move>()
    private var nextURL: URL? {
        didSet {
            if nextURL != nil { hasNextPage = true }
            else { hasNextPage = false }
        }
    }
    @Published private(set) var hasNextPage = false
    @Published private(set) var isLoading = false
    @Published var viewHasAppeared = false
    private let limit = 20
}

extension MoveGridViewViewModel {
    func getMoves() async {
        guard let resourceList = try? await PokeAPI.shared.getResourceList(fromEndpoint: "move", limit: limit) else {
            print("Error in \(#function) at line: \(#line). Resource list is nil.")
            return
        }
        isLoading = true
        nextURL = resourceList.next
        await withTaskGroup(of: Move?.self) { group in
            for resource in resourceList.results {
                group.addTask {
                    let move = try? await Move.from(name: resource.name)
                    return move
                }
            }
            
            var tempMoves = Set<Move>()
            for await move in group {
                if let move {
                    tempMoves.insert(move)
                }
            }
            self.moves = tempMoves
            isLoading = false
        }
        
    }
    
    func getNextMovesPage() async {
        if isLoading { return }
        guard let nextURL else { return }
        
        
        guard let resourceList = try? await PokeAPI.shared.getData(for: NamedAPIResourceList.self, url: nextURL) else {
            return
        }
        
        self.nextURL = resourceList.next
        print(resourceList.results)
        let (moves, otherURL) = await PokeAPI.shared.getItems(ofType: Move.self, from: resourceList)
        self.nextURL = otherURL
        self.moves.formUnion(moves)
        
    }
    
    func filteredMoves(searchText: String) -> [Move] {
        if searchText.isEmpty { return moves.sorted() }
        
        if let id = Int(searchText) {
            return moves.filter { move in
                move.id == id
            }
            .sorted()
        }
        
        return moves.filter { move in
            move.name.contains(searchText)
        }
        .sorted()
    }
}
