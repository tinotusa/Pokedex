//
//  TypeDetailViewModel.swift
//  Pokedex
//
//  Created by Tino on 14/9/2022.
//

import SwiftUI

final class TypeDetailViewModel: ObservableObject {
    @Published private(set) var viewState = ViewState.loading
    @Published private(set) var damageRelations = [TypeRelationKey: [NamedAPIResource]]()
    @Published private(set) var typeInfo = [TypeInfoKey: String]()
    @Published var showPokemonList = false
    private var type: `Type`?
    private var settings: Settings?
}

extension TypeDetailViewModel {
    enum TypeRelationKey: String, CaseIterable, Identifiable {
        case noDamageTo = "no damage to"
        case halfDamageTo = "half damage to"
        case doubleDamageTo = "double damage to"
        case noDamageFrom = "no damage from"
        case halfDamageFrom = "half damage from"
        case doubleDamageFrom = "double damage from"
        
        var id: Self { self }
        
        var title: LocalizedStringKey {
            LocalizedStringKey(self.rawValue.localizedCapitalized)
        }
    }
    
    enum TypeInfoKey: String, CaseIterable, Identifiable {
        case gameIndices = "game indices"
        case generation
        case moveDamageClass = "move damage class"
        case pokemon
        case moves
        
        var id: Self { self }
        
        var title: LocalizedStringKey {
            LocalizedStringKey(self.rawValue.localizedCapitalized)
        }
    }
    
    func getTypeInfo() {
        guard let type else { return }
        typeInfo[.gameIndices] = "\(type.gameIndices.count)"
        typeInfo[.generation] = type.generation.name
        if let moveDamageClass = type.moveDamageClass {
            typeInfo[.moveDamageClass] = moveDamageClass.name
        } else {
            typeInfo[.moveDamageClass] = "N/A"
        }
        typeInfo[.pokemon] = "\(type.pokemon.count) pokemon"
        typeInfo[.moves] = "\(type.moves.count) moves"
    }
    
    func getDamageRelations() {
        guard let type else { return }
        damageRelations[.noDamageTo] = type.damageRelations.noDamageTo
        damageRelations[.halfDamageTo] = type.damageRelations.halfDamageTo
        damageRelations[.doubleDamageTo] = type.damageRelations.doubleDamageTo
        damageRelations[.noDamageFrom] = type.damageRelations.noDamageFrom
        damageRelations[.halfDamageFrom] = type.damageRelations.halfDamageFrom
        damageRelations[.doubleDamageFrom] = type.damageRelations.doubleDamageFrom
    }
    
    var localizedTypeName: String {
        guard let type else { return "Error" }
        return type.names.localizedName(language: settings?.language, default: type.name)
    }
}

extension TypeDetailViewModel {
    func loadData(type: `Type`, settings: Settings) {
        setUp(type: type, settings: settings)
        getDamageRelations()
        getTypeInfo()
        viewState = .loaded
    }
}

private extension TypeDetailViewModel {
    func setUp(type: `Type`, settings: Settings) {
        self.type = type
        self.settings = settings
    }
}
