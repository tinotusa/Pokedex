//
//  PokemonSpeciesListViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 21/9/2022.
//

import Foundation
import os

final class PokemonSpeciesListViewViewModel: ObservableObject {
    /// A sorted array of pokemon.
    @Published private(set) var pokemon = [Pokemon]()
    /// A sorted array of pokemon species.
    @Published private(set) var pokemonSpecies = [PokemonSpecies]()
    @Published private(set) var viewState = ViewState.loading
    @Published private(set) var hasNextPage = true
    
    private let limit = 20
    private var offset = 0
    private var page = 0 {
        didSet {
            offset = page * limit
        }
    }
    
    private var settings: Settings?
    private var urls = [URL]()
    private var logger = Logger(subsystem: "com.tinotusa.Pokedex", category: "PokemonSpeciesListViewViewModel")
}

// MARK: - Public
extension PokemonSpeciesListViewViewModel {
    @MainActor
    func loadData(urls: [URL], settings: Settings) async {
        logger.debug("Starting to download pokemon species. url count: \(urls.count)")
        
        setUp(urls: urls, settings: settings)
        if urls.isEmpty {
            viewState = .empty
            logger.debug("Failed to load data. URLs array is empty.")
            return
        }
        
        let pokemonSpecies = await getPokemonSpecies().sorted()
        let pokemon = await getPokemon(from: pokemonSpecies).sorted()
        
        self.pokemon = pokemon
        self.pokemonSpecies = pokemonSpecies
        
        
        if pokemonSpecies.count < limit {
            logger.debug("Pokemon species count is below the limit. page: \(self.page), count: \(pokemonSpecies.count), limit: \(self.limit)")
            hasNextPage = false
        }
        
        viewState = .loaded
        page += 1
        
        logger.debug("Successfully downloaded pokemon species. url count: \(urls.count)")
    }
    
    @MainActor
    func getNextPage() async {
        logger.debug("Starting to get next page. page: \(self.page), offset: \(self.offset)")
        let pokemonSpecies = await getNextPokemonSpeciesPage().sorted()
        let pokemon = await getNextPokemonPage(from: pokemonSpecies).sorted()
        self.pokemon.append(contentsOf: pokemon)
        self.pokemonSpecies.append(contentsOf: pokemonSpecies)
        
        
        if pokemonSpecies.count < limit {
            logger.debug("No more pokemon species left")
            hasNextPage = false
        }
        
        page += 1
        logger.debug("Successfully got next page. next page: \(self.page),  next offset: \(self.offset)")
    }
    
    func getPokemon(withID id: Int) -> Pokemon? {
        pokemon.first { $0.id == id }
    }
    
    func localizedPokemonName(pokemonSpecies: PokemonSpecies) -> String {
        guard let settings else {
            logger.debug("Failed to get localized pokemon name. settings is nil.")
            return "Error"
        }
        return pokemonSpecies.names.localizedName(language: settings.language, default: pokemonSpecies.name)
    }
}

// MARK: - Computed properties
extension PokemonSpeciesListViewViewModel {
    
}


// MARK: - Private
private extension PokemonSpeciesListViewViewModel {
    func setUp(urls: [URL], settings: Settings) {
        self.urls = urls
        self.settings = settings
    }
    
    func getPokemonSpecies() async -> [PokemonSpecies] {
        logger.debug("Starting download for Pokemon species.")
        
        let pokemonSpecies = await withTaskGroup(of: PokemonSpecies?.self) { group in
            for (i, url) in urls.enumerated() where i < limit {
                group.addTask { [weak self] in
                    do {
                        return try await PokemonSpecies.from(url: url)
                    } catch {
                        self?.logger.debug("Failed to download PokemonSpecies from url: \(url)")
                    }
                    return nil
                }
            }
            var tempSpecies = [PokemonSpecies]()
            for await pokemonSpecies in group {
                guard let pokemonSpecies else {
                    logger.debug("A pokemon species is nil")
                    continue
                }
                tempSpecies.append(pokemonSpecies)
            }
            return tempSpecies
        }
        
        logger.debug("Successfully download pokemon species (count: \(pokemonSpecies.count))")
        return pokemonSpecies
    }
    
    func getNextPokemonSpeciesPage() async -> [PokemonSpecies] {
        logger.debug("Starting download for next PokemonSpecies. page: \(self.page) offset: \(self.offset)")
        let species = await withTaskGroup(of: PokemonSpecies?.self) { group in
            for (i, url) in urls.enumerated()
                where i >= offset && i < offset + limit
            {
                group.addTask { [weak self] in
                    do {
                        return try await PokemonSpecies.from(url: url)
                    } catch {
                        self?.logger.debug("Failed to download PokemonSpecies from url: \(url)")
                    }
                    return nil
                }
            }
            
            var tempSpecies = [PokemonSpecies]()
            for await pokemonSpecies in group {
                guard let pokemonSpecies else {
                    logger.debug("PokemonSpecies is nil")
                    continue
                }
                tempSpecies.append(pokemonSpecies)
            }
            return tempSpecies
        }
        return species
    }
    
    func getPokemon(from pokemonSpecies: [PokemonSpecies]) async -> [Pokemon] {
        logger.debug("Starting download for pokemon. Species count: \(pokemonSpecies.count)")
        let pokemon = await withTaskGroup(of: Pokemon?.self) { group in
            for species in pokemonSpecies {
                group.addTask { [weak self] in
                    do {
                        return try await Pokemon.from(id: species.id)
                    } catch {
                        self?.logger.debug("Failed to download Pokemon from PokemonSpecies id: \(species.id)")
                    }
                    return nil
                }
            }
            
            var tempPokemon = [Pokemon]()
            for await pokemon in group {
                guard let pokemon else {
                    logger.debug("Pokemon is nil.")
                    continue
                }
                tempPokemon.append(pokemon)
            }
            return tempPokemon
        }
        logger.debug("Successfully download Pokemon from PokemonSpecies. Pokemon count: \(pokemon.count)")
        return pokemon
    }
    
    func getNextPokemonPage(from pokemonArray: [PokemonSpecies]) async -> [Pokemon] {
        logger.debug("Starting to download next pokemon page. page: \(self.page) offset: \(self.offset)")
        
        let pokemon = await withTaskGroup(of: Pokemon?.self) { group in
            for pokemon in pokemonArray {
                group.addTask { [weak self] in
                    do {
                        return try await Pokemon.from(id: pokemon.id)
                    } catch {
                        self?.logger.debug("Failed to download pokemon from pokemon species is: \(pokemon.id)")
                    }
                    return nil
                }
            }
            var tempPokemon = [Pokemon]()
            for await pokemon in group {
                guard let pokemon else {
                    logger.debug("Failed to download a pokemon.")
                    continue
                }
                tempPokemon.append(pokemon)
            }
            return tempPokemon
        }
        
        logger.debug("Successfully downloaded next pokemon page. download count: \(pokemon.count)")
        return pokemon
    }
}
