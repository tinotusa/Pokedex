//
//  EvolutionChainLinkRowViewModel.swift
//  Pokedex
//
//  Created by Tino on 1/9/2022.
//

import Foundation

@MainActor
final class EvolutionChainLinkRowViewModel: ObservableObject {
    private var chainLink: ChainLink?
    private var settings: Settings?
    
    @Published private(set) var pokemon: Pokemon?
    @Published private(set) var pokemonSpecies: PokemonSpecies?
    @Published private(set) var viewState = ViewState.loading
}

extension EvolutionChainLinkRowViewModel {
    enum EvolutionChainError: Error, LocalizedError {
        case noPokemonSpecies
        
        var errorDescription: String? {
            switch self {
            case .noPokemonSpecies: return "Pokemon species could not be decoded."
            }
        }
        
        var failureReason: String? {
            switch self {
            case .noPokemonSpecies: return "The chain link's pokemon species is nil."
            }
        }
        
        var recoverySuggestion: String? {
            switch self {
            case .noPokemonSpecies: return "Check that the chain links pokemon species field is not null."
            }
        }
    }
}

// MARK: Private
private extension EvolutionChainLinkRowViewModel {
    private func setUp(chainLink: ChainLink, settings: Settings = .default) {
        self.chainLink = chainLink
        self.settings = settings
    }
}

// MARK: Functions
extension EvolutionChainLinkRowViewModel {
    func loadData(chainLink: ChainLink, settings: Settings) async {
        setUp(chainLink: chainLink, settings: settings)
        do {
            pokemonSpecies = try await PokeAPI.shared.getData(for: PokemonSpecies.self, url: chainLink.species.url)
            guard let pokemonSpecies else {
                #if DEBUG
                print("Error in \(#function). pokemonSpecies is nil.")
                #endif
                viewState = .error(EvolutionChainError.noPokemonSpecies)
                return
            }
            pokemon = try await Pokemon.from(id: pokemonSpecies.id)
            viewState = .loaded
        } catch {
            viewState = .error(error)
        }
    }
    
    var localizedPokemonName: String {
        guard let pokemonSpecies else { return "Error" }
        guard let settings else { return "Error" }
        return pokemonSpecies.names.localizedName(language: settings.language, default: pokemonSpecies.name)
    }
}
