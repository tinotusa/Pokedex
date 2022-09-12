//
//  MoveCardViewModel.swift
//  Pokedex
//
//  Created by Tino on 2/9/2022.
//

import Foundation

@MainActor
final class MoveCardViewModel: ObservableObject {
    @Published private var move: Move?
    @Published private var settings: Settings?
    
    @Published var moveDamageClass: MoveDamageClass?
}

extension MoveCardViewModel {
    private func setUp(move: Move, settings: Settings) {
        self.settings = settings
        self.move = move
    }
    
    func loadData(move: Move, settings: Settings) async {
        setUp(move: move, settings: settings)
        moveDamageClass = try? await MoveDamageClass.from(name: move.damageClass.name)
    }
}

extension MoveCardViewModel {
    var localizedDamageClassName: String {
        guard let moveDamageClass else {
            print("Error in \(#function). moveDamageClass is nil.")
            return "Error"
        }
        guard let move else {
            print("Error in \(#function). move is nil.")
            return "Error"
        }
        guard let settings else {
            print("Error in \(#function). settings is nil.")
            return "Error"
        }
        
        return moveDamageClass.names
            .localizedName(
                language: settings.language,
                default: move.damageClass.name
            )
            .capitalized
    }
    
    var localizedMoveName: String {
        guard let move else { return "Error" }
        guard let settings else { return "Error" }
        return move.names.localizedName(language: settings.language, default: move.name)
    }
    
    var moveID: String {
        guard let move else { return "Error" }
        return String(format: "#%03d", move.id)
    }
    
    var localizedMoveShortEffect: String {
        guard let move else { return "Error" }
        guard let settings else { return "Error" }
        
        return move.effectEntries.localizedEffectEntry(
            shortEffect: true,
            language: settings.language,
            default: move.effectEntries.first?.shortEffect ?? "Error",
            effectChance: move.effectChance
        )
    }
}
