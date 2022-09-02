//
//  EvolutionChainViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import SwiftUI

@MainActor
final class EvolutionChainLinkViewModel: ObservableObject {
    var chainLink: ChainLink?
    
    @Published private(set) var pokemon: Pokemon?
    @Published private(set) var pokemonSpecies: PokemonSpecies?
    @Published private(set) var evolutionTrigger: EvolutionTrigger?
    @Published private(set) var evolutionChainLinks = [ChainLink]()
    
    @Published var viewHasAppeared = false
    
    var localizedPokemonName: String {
        guard let pokemonSpecies else { return "Error" }
        return pokemonSpecies.names.localizedName(default: "Error")
    }
    
    var pokemonImageURL: URL? {
        return pokemon?.officialArtWork
    }
    
    var localizedEvolutionTriggerName: String {
        guard let evolutionTrigger else { return "Error" }
        return evolutionTrigger.names.localizedName(default: "Error")
    }
}

extension EvolutionChainLinkViewModel {
    var wrappedChainLink: ChainLink {
        if let chainLink {
            return chainLink
        }
        fatalError("chainLink is nil. Call setUp(chainLink:) before calling other functions.")
    }
}

extension EvolutionChainLinkViewModel {
    func setUp(chainLink: ChainLink) {
        self.chainLink = chainLink
    }
    
    func loadData() async {
        pokemonSpecies = try? await PokemonSpecies.from(name: wrappedChainLink.species.name)
        if let pokemonSpecies {
            pokemon = try? await Pokemon.from(id: pokemonSpecies.id)
        } else {
            print("Error in \(#function). pokemonSpecies is nil.")
        }
        if let evolutionDetails = wrappedChainLink.evolutionDetails, !evolutionDetails.isEmpty {
            evolutionTrigger = try? await EvolutionTrigger.from(name: evolutionDetails.first!.trigger.name)
        }
    }
    
    func getAllChains() {
        
        var stack = [wrappedChainLink]
        var temp = [ChainLink]()
        while !stack.isEmpty {
            guard let link = stack.popLast() else { break }
            temp.append(link)
            stack.append(contentsOf: link.evolvesTo)
        }
        evolutionChainLinks = temp
    }
}


private extension EvolutionChainLinkViewModel {
    
}
