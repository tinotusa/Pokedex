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
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        VStack(alignment: .leading) {
            PopoverNavigationBar()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    nameAndIDRow
                    
                    Text("Pokemon that can hold this item.")
                    
                    Divider()
                    switch viewModel.viewState {
                    case .loading:
                        LoadingView()
                            .task {
                                await viewModel.loadData(itemHolderPokemon: itemDetailViewModel.item?.heldByPokemon)
                            }
                    case .loaded:
                        pokemonList
                    case .error(let error):
                        Text(error.localizedDescription)
                    case .empty:
                        Text("Empty")
                    }
                }
            }
            
            Spacer()
        }
        .bodyStyle()
        .foregroundColor(.textColour)
        .padding()
        .backgroundColour()
        .preferredColorScheme(settingsManager.isDarkMode ? .dark : .light)
        .toolbar(.hidden)
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
                    Text(pokemonSpecies.localizedName(language: settingsManager.language))
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
        Task {
            await itemDetail.loadData(item: .example, settings: .default)
        }
        return itemDetail
    }()
    
    static var previews: some View {
        NavigationStack {
            ItemPokemonListView(itemDetailViewModel: viewModel)
                .environmentObject(ImageCache())
                .environmentObject(SettingsManager())
        }
    }
}
