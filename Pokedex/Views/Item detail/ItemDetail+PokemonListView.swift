//
//  ItemDetail+PokemonListView.swift
//  Pokedex
//
//  Created by Tino on 31/8/2022.
//

import SwiftUI

extension ItemDetail {
    struct PokemonListView: View {
        @ObservedObject var itemDetailViewModel: ItemDetailViewModel
        @StateObject var viewModel = PokemonListViewViewModel()
        @Environment(\.appSettings) var appSettings
        @Environment(\.dismiss) var dismiss
        
        var body: some View {
            Group {
                if !viewModel.viewHasAppeared {
                    LoadingView()
                        .frame(maxWidth: .infinity)
                } else {
                    pokemonListView
                }
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
}

private extension ItemDetail.PokemonListView {
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
    
    var pokemonListView: some View {
        VStack(alignment: .leading) {
            PopoverNavigationBar {
                dismiss()
            }
            
            ScrollView {
                VStack(alignment: .leading) {
                    nameAndIDRow
                    
                    Text("Pokemon that can hold this item.")
                    
                    Divider()
                    
                    ForEach(viewModel.pokemon) { pokemon in
                        HStack {
                            smallPokemonImage(url: pokemon.sprites.frontDefault)
                            
                            if let pokemonSpecies = viewModel.getPokemonSpecies(id: pokemon.id) {
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
            }
            
            Spacer()
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
        .frame(width: Constants.smallImageSize)
    }
    
    enum Constants {
        static let smallImageSize = 50.0
    }
}

struct ItemDetail_PokemonListView_Previews: PreviewProvider {
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
            ItemDetail.PokemonListView(itemDetailViewModel: viewModel)
                .environmentObject(ImageCache())
        }
    }
}
