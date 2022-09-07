//
//  ItemPokemonListView.swift
//  Pokedex
//
//  Created by Tino on 31/8/2022.
//

import SwiftUI


struct ItemPokemonListView: View {
    @ObservedObject var itemDetailViewModel: ItemDetailViewModel
    @StateObject var viewModel = ItemPokemonListViewViewModel()
    @Environment(\.appSettings) var appSettings
    
    var body: some View {
        VStack(alignment: .leading) {
            PopoverNavigationBar()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    nameAndIDRow
                    
                    Text("Pokemon that can hold this item.")
                    
                    Divider()
                    if !viewModel.viewHasAppeared {
                        LoadingView()
                    } else {
                        pokemonList
                    }
                }
            }
            
            Spacer()
        }
        .toolbar(.hidden)
        .bodyStyle()
        .foregroundColor(.textColour)
        .padding(.horizontal)
        .background {
            Color.backgroundColour
                .ignoresSafeArea()
        }
        .task {
            if !viewModel.viewHasAppeared {
                await viewModel.loadData(itemHolderPokemon: itemDetailViewModel.item?.heldByPokemon ?? [])
                viewModel.viewHasAppeared = true
            }
        }
    }
}


private extension ItemPokemonListView {
    var nameAndIDRow: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(itemDetailViewModel.localizedItemName)
                Spacer()
                Text(itemDetailViewModel.itemID)
                    .fontWeight(.ultraLight)
            }
            .headerStyle()
            Divider()
        }
    }
    
    var pokemonList: some View {
        ForEach(viewModel.sortedPokemon) { pokemon in
            HStack {
                smallPokemonImage(url: pokemon.sprites.frontDefault)
                
                if let pokemonSpecies = viewModel.getPokemonSpecies(named: pokemon.species.name) {
                    Text(pokemonSpecies.localizedName(language: appSettings.language))
                        .textSelection(.enabled)
                    Spacer()
                    Text(pokemon.formattedID)
                        .foregroundColor(.gray)
                        .textSelection(.enabled)
                }
                
            }
        }
    }
    
    @ViewBuilder
    func smallPokemonImage(url: URL?) -> some View {
        ImageLoaderView(url: url) {
            ProgressView()
        } content: { image in
            image
                .interpolation(.none)
                .resizable()
                .scaledToFit()
        }
        .frame(width: Constants.smallImageSize, height: Constants.smallImageSize)
    }
    
    enum Constants {
        static let smallImageSize = 50.0
    }
}

struct ItemPokemonListView_Previews: PreviewProvider {
    static var viewModel = {
        let itemDetail = ItemDetailViewModel()
        itemDetail.setUp(item: .example, settings: .default)
        Task {
            await itemDetail.loadData()
        }
        return itemDetail
    }()
    
    static var previews: some View {
        NavigationStack {
            ItemPokemonListView(itemDetailViewModel: viewModel)
                .environmentObject(ImageCache())
        }
    }
}
