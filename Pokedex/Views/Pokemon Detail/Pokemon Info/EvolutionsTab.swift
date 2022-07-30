//
//  EvolutionsTab.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

final class EvolutionTriggerEventsViewViewModel: ObservableObject {
    let evolutionDetail: EvolutionDetail
    @Published private(set) var localizedEvolutionTriggerName: String?
    @Published private(set) var localizedItemName: String?
    @Published private(set) var localizedHeldItemName: String?
    @Published private(set) var localizedKnownMoveName: String?
    
    init(evolutionDetail: EvolutionDetail) {
        self.evolutionDetail = evolutionDetail
    }
    
    @MainActor
    func setUp() async {
        localizedEvolutionTriggerName = await getLocalizedTriggerName()
        localizedItemName = await getLocalizedItemName()
        localizedHeldItemName = await getLocalizedHeldItemName()
        localizedKnownMoveName = await getLocalizedKnownMove()
    }
    
    func getLocalizedTriggerName() async -> String? {
        guard let trigger = await EvolutionTrigger.from(name: evolutionDetail.trigger.name) else {
            return nil
        }
        return trigger.names.localizedName
    }
    
    func getLocalizedHeldItemName() async -> String? {
        guard let heldItem = evolutionDetail.heldItem else { return nil }
        let item = await Item.from(name: heldItem.name)
        return item?.names.localizedName
    }
    
    func getLocalizedItemName() async -> String? {
        guard let evolutionItem = evolutionDetail.item else {
            return nil
        }
        let item = await Item.from(name: evolutionItem.name)
        return item?.names.localizedName
    }
    
    func getLocalizedKnownMove() async -> String? {
        guard let knownMove = evolutionDetail.knownMove else { return nil }
        let move = await Move.from(name: knownMove.name)
        return move?.names.localizedName
    }
}

struct EvolutionTriggerEventsView: View {
    @StateObject private var viewModel: EvolutionTriggerEventsViewViewModel
    
    init(evolutionDetail: EvolutionDetail) {
        _viewModel = StateObject(wrappedValue: EvolutionTriggerEventsViewViewModel(evolutionDetail: evolutionDetail))
    }
    
    var body: some View {
        VStack {
            Text(
                "Evolution trigger: \(viewModel.localizedEvolutionTriggerName ?? "Error")",
                comment: "Evolution trigger is the action that causes the pokemon to evolve."
            )
            if let itemName = viewModel.localizedItemName {
                Text("Item: \(itemName)", comment: "The item required to level up the pokemon.")
            }
            if let gender = viewModel.evolutionDetail.gender {
                Text("Gender: \(gender)", comment: "The gender the pokemon must be in inorder to evolve.")
            }
            if let heldItemName = viewModel.localizedHeldItemName {
                Text("Held item: \(heldItemName)", comment: "The name of the held item.")
            }
            if let knownMoveName = viewModel.localizedKnownMoveName {
                Text("Known move: \(knownMoveName)")
            }
        }
        .task {
            await viewModel.setUp()
        }
    }
}

struct EvolutionChainView: View {
    let chain: ChainLink
    let size = 170.0
    @StateObject var viewModel: EvolutionChainViewViewModel
    
    init(chain: ChainLink) {
        self.chain = chain
        _viewModel = StateObject(wrappedValue: EvolutionChainViewViewModel(chainLink: chain))
    }
    
    var body: some View {
        NavigationLink(value: viewModel.pokemon) {
            VStack {
                HStack {
                    Text(viewModel.localizedPokemonName)
                    if let pokemon = viewModel.pokemon {
                        Text("(#\(pokemon.id))")
                    }
                }
                HStack{
                    AsyncImage(url: viewModel.pokemonImageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: size, height: size)
                    } placeholder: {
                        ProgressView()
                            .frame(width: size, height: size)
                    }
                    ForEach(viewModel.chainLink.evolutionDetails ?? [], id: \.self) { evolutionDetail in
                        EvolutionTriggerEventsView(evolutionDetail: evolutionDetail)
                    }
                }
                HStack {
                    ForEach(viewModel.pokemon?.types ?? [], id: \.self) { type in
                        PokemonTypeTag(name: type.type.name)
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .task {
            await viewModel.setUp()
        }
    }
}

struct EvolutionsTab: View {
    @StateObject private var viewModel: EvolutionsTabViewModel
    
    init(pokemon: Pokemon) {
        _viewModel = StateObject(wrappedValue: EvolutionsTabViewModel(pokemon: pokemon))
    }
    
    var body: some View {
        VStack {
            if let evolutionChain = viewModel.evolutionChain {
                ForEach(evolutionChain.allEvolutions(), id: \.self) { chain in
                    EvolutionChainView(chain: chain)
                }
            } else {
                Text(
                    "This Pokemon has no evolutions.",
                    comment: "Placeholder text to show that this pokemon cannot evolve into another one."
                )
                .foregroundColor(.secondary)
            }
        }
        .task {
            await viewModel.setUp()
        }
    }
}

struct EvolutionsTab_Previews: PreviewProvider {
    static var previews: some View {
        EvolutionsTab(pokemon: .example)
    }
}
