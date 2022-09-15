//
//  MovesListViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 15/9/2022.
//

import Foundation

final class MovesListViewViewModel: ObservableObject {
    @Published private(set) var viewState = ViewState.loading
    @Published private var moves = [Move]()
    @Published private(set) var hasNextPage = true
    
    private var settings: Settings?
    private var moveURLS = [URL]()
    
    private let limit = 20
    private var offset = 0
    private var page = 0 {
        didSet {
            offset = page * limit
        }
    }
}

extension MovesListViewViewModel {
    var sortedMoves: [Move] {
        moves.sorted()
    }
    
    func loadData(moveURLS: [URL], settings: Settings) async {
        setUp(moveURLS: moveURLS, settings: settings)
        if moveURLS.isEmpty {
            viewState = .empty
            return
        }
        
        let moves = await getMoves()
        self.moves = moves
        
        if moves.count < limit {
            hasNextPage = false
        }
        
        page += 1
        
        viewState = .loaded
    }
    
    func getNextPage() async {
        let moves = await getNextMovePage()
        self.moves.append(contentsOf: moves)
        
        if moves.count < limit {
            hasNextPage = false
        }
        page += 1
    }
}

private extension MovesListViewViewModel {
    func setUp(moveURLS: [URL], settings: Settings) {
        self.moveURLS = moveURLS
        self.settings = settings
    }
    
    func getMoves() async -> [Move] {
        await withTaskGroup(of: Move?.self) { group in
            for (i, url) in moveURLS.enumerated() where i < limit {
                group.addTask {
                    do {
                        return try await Move.from(url: url)
                    } catch {
                        #if DEBUG
                        print("Error in \(#function).\n\(error)")
                        #endif
                    }
                    return nil
                }
            }
            var moves = [Move]()
            for await move in group {
                guard let move else { continue }
                moves.append(move)
            }
            return moves
        }
    }
    
    func getNextMovePage() async -> [Move] {
        await withTaskGroup(of: Move?.self) { group in
            for (i, url) in moveURLS.enumerated()
                where i >= offset && i < offset + limit
            {
                group.addTask {
                    do {
                        return try await Move.from(url: url)
                    } catch {
                        #if DEBUG
                        print("Error in \(#function).\n\(error)")
                        #endif
                    }
                    return nil
                }
            }
            var moves = [Move]()
            for await move in group {
                guard let move else { continue }
                moves.append(move)
            }
            return moves
        }
    }
}
