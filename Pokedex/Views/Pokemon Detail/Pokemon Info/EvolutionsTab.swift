//
//  EvolutionsTab.swift
//  Pokedex
//
//  Created by Tino on 23/7/2022.
//

import SwiftUI

final class EvolutionTriggerEventsViewViewModel: ObservableObject {
    let evolutionDetail: EvolutionDetail
    @Published var localizedEvolutionTriggerName: String?
    
    init(evolutionDetail: EvolutionDetail) {
        self.evolutionDetail = evolutionDetail
    }
    
    var wrappedLocalizedEvolutionTriggerName: String {
        localizedEvolutionTriggerName ?? evolutionDetail.trigger.name
    }
    
    func item() {
        
    }
    
    @MainActor
    func setUp() async {
        localizedEvolutionTriggerName = await getLocalizedTriggerName()
    }
    
    func getLocalizedTriggerName() async -> String {
        guard let trigger = await EvolutionTrigger.from(name: evolutionDetail.trigger.name) else {
            return evolutionDetail.trigger.name
        }
        return trigger.names.localizedName ?? evolutionDetail.trigger.name
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
                "Evolution trigger: \(viewModel.wrappedLocalizedEvolutionTriggerName)",
                comment: "Evolution trigger is the action that causes the pokemon to evolve."
            )
            if let item = viewModel.item {
                item.name
            }
        }
        .task {
            await viewModel.setUp()
        }
    }
}

struct EvolutionChainView: View {
    let chain: ChainLink
    let size = 200.0
    @StateObject var viewModel: EvolutionChainViewViewModel
    
    init(chain: ChainLink) {
        self.chain = chain
        _viewModel = StateObject(wrappedValue: EvolutionChainViewViewModel(chainLink: chain))
    }
    
    var body: some View {
        NavigationLink(value: viewModel.pokemon) {
            VStack {
                if let evolutionDetails = chain.evolutionDetails, !evolutionDetails.isEmpty {
                    Text("Trigger: \(viewModel.localizedEvolutionTriggerName)", comment: "The action that makes the pokemon evolve")
                    Text("\(evolutionDetails.first!.minLevel ?? 0)")
                }
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
                    comment: "Placeholder text to show that this pokemon cannot change into another one."
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
