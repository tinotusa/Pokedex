//
//  HomeMovesTabViewModel.swift
//  Pokedex
//
//  Created by Tino on 20/8/2022.
//

import SwiftUI

@MainActor
final class HomeMovesTabViewModel: ObservableObject {
    @Published var moves = Set<Move>()
    private var nextURL: URL? {
        didSet {
            if nextURL != nil { hasNextPage = true }
            else { hasNextPage = false }
        }
    }
    @Published private(set) var hasNextPage = false
    @Published private(set) var viewState = ViewState.loading
    @Published private(set) var searchState = SearchState.idle
    @Published var searchText = "" {
        didSet {
            Task {
                await getMove()
            }
        }
    }
    private var task: Task<Void, Never>?
    private let limit = 20
}

private extension HomeMovesTabViewModel {
    func resetSearchState() {
        searchState = .idle
    }
}

extension HomeMovesTabViewModel {
    func getMove() async {
        resetSearchState()
        
        task?.cancel()
        
        if Task.isCancelled { return }
        if searchText.isEmpty { return }
        
        searchState = .searching
        task = Task {
            if moves.containsItem(named: searchText) {
                searchState = .done
                return
            }
            
            guard let move = try? await Move.from(name: searchText) else {
                searchState = .error
                return
            }
            
            self.moves.insert(move)
            searchState = .done
        }
    }
    
    func getMoves() async {
        guard let resourceList = try? await PokeAPI.shared.getResourceList(fromEndpoint: "move", limit: limit) else {
            print("Error in \(#function) at line: \(#line). Resource list is nil.")
            return
        }
        
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
            viewState = .loaded
        }
        
    }
    
    func getNextMovesPage() async {
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
    
    var filteredMoves: [Move] {
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
