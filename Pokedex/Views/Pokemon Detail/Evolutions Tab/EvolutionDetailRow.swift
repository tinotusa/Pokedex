//
//  EvolutionDetailRow.swift
//  Pokedex
//
//  Created by Tino on 2/9/2022.
//

import SwiftUI

struct EvolutionDetailRow: View {
    let evolutionDetail: EvolutionDetail
    @StateObject private var viewModel = EvolutionDetailRowViewModel()
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        Grid(alignment: .leadingFirstTextBaseline) {
            Group {
                evolutionTrigger(evolutionDetail: evolutionDetail)
                minLevel(evolutionDetail: evolutionDetail)
                minHappiness(evolutionDetail: evolutionDetail)
                minBeauty(evolutionDetail: evolutionDetail)
                gender(evolutionDetail: evolutionDetail)
                item(evolutionDetail: evolutionDetail)
                heldItem(evolutionDetail: evolutionDetail)
                knownMove(evolutionDetail: evolutionDetail)
                knownMoveType(evolutionDetail: evolutionDetail)
                location(evolutionDetail: evolutionDetail)
            }
            Group {
                minAffection(evolutionDetail: evolutionDetail)
                needsOverworldRain(evolutionDetail: evolutionDetail)
                partySpecies(evolutionDetail: evolutionDetail)
                partyType(evolutionDetail: evolutionDetail)
                relativePhysicalStats(evolutionDetail: evolutionDetail)
                timeOfDay(evolutionDetail: evolutionDetail)
                tradeSpecies(evolutionDetail: evolutionDetail)
                turnUpsideDown(evolutionDetail: evolutionDetail)
            }
        }
        .task {
            viewModel.setUp(settings: settingsManager.settings)
        }
    }
}

private extension EvolutionDetailRow {
    enum Constants {
        static let imageSize = 140.0
        static let itemImageSize = 40.0
    }
}


// MARK: Subviews
private extension EvolutionDetailRow {
    @ViewBuilder
    func evolutionTrigger(evolutionDetail: EvolutionDetail) -> some View {
        GridRow {
            Text("Trigger")
                .gridRowTitleStyle()
            Text(viewModel.localizedTrigger)
        }
        .task {
            await viewModel.getEvolutionTrigger(named: evolutionDetail.trigger.name)
        }
    }
    
    @ViewBuilder
    func gender(evolutionDetail: EvolutionDetail) -> some View {
        if let gender = evolutionDetail.gender {
            GridRow {
                Text("Gender")
                    .gridRowTitleStyle()
                switch gender {
                case 1: Text("Female")
                case 2: Text("Male")
                default: Text("Genderless")
                }
            }
        }
    }
    
    @ViewBuilder
    func heldItem(evolutionDetail: EvolutionDetail) -> some View {
        if let heldItem = evolutionDetail.heldItem {
            GridRow {
                Text("Held item")
                    .gridRowTitleStyle()
                LabeledImage(
                    imageURL: viewModel.heldItem?.sprites.default,
                    label: viewModel.localizedHeldItemName,
                    imageSize: Constants.itemImageSize
                )
            }
            .id(UUID())
            .task {
                await viewModel.getHeldItem(named: heldItem.name)
            }
        }
    }
    
    @ViewBuilder
    func item(evolutionDetail: EvolutionDetail) -> some View {
        if let item = evolutionDetail.item {
            GridRow {
                Text("Item")
                    .gridRowTitleStyle()
                LabeledImage(
                    imageURL: viewModel.item?.sprites.default,
                    label: viewModel.localizedItemName,
                    imageSize: Constants.itemImageSize)
            }
            .id(UUID())
            .task {
                await viewModel.getItem(named: item.name)
            }
        }
    }
    
    @ViewBuilder
    func knownMove(evolutionDetail: EvolutionDetail) -> some View {
        if let knownMove = evolutionDetail.knownMove {
            GridRow {
                Text("Known move")
                    .gridRowTitleStyle()
                Text(viewModel.localizedKnownMoveName)
            }
            .task {
                await viewModel.getKnownMove(named: knownMove.name)
            }
        }
    }
    
    @ViewBuilder
    func knownMoveType(evolutionDetail: EvolutionDetail) -> some View {
        if let knownMoveType = evolutionDetail.knownMoveType {
            GridRow {
                Text("Known move type")
                    .gridRowTitleStyle()
                PokemonTypeTag(namedAPIResource: knownMoveType)
            }
        }
    }
    
    @ViewBuilder
    func location(evolutionDetail: EvolutionDetail) -> some View {
        if let location = evolutionDetail.location {
            GridRow {
                Text("Location")
                    .gridRowTitleStyle()
                Text(viewModel.localizedLocationName)
            }
            .task {
                await viewModel.getLocation(named: location.name)
            }
        }
    }
    
    @ViewBuilder
    func minLevel(evolutionDetail: EvolutionDetail) -> some View {
        if let minLevel = evolutionDetail.minLevel {
            GridRow {
                Text("Min level")
                    .gridRowTitleStyle()
                Text("\(minLevel)")
            }
        }
    }
    
    @ViewBuilder
    func minHappiness(evolutionDetail: EvolutionDetail) -> some View {
        if let minHappiness = evolutionDetail.minHappiness {
            GridRow {
                Text("Min happiness")
                    .gridRowTitleStyle()
                Text("\(minHappiness)")
            }
        }
    }
    
    @ViewBuilder
    func minBeauty(evolutionDetail: EvolutionDetail) -> some View {
        if let minBeauty = evolutionDetail.minBeauty {
            GridRow {
                Text("Min beauty")
                    .gridRowTitleStyle()
                Text("\(minBeauty)")
            }
        }
    }
    
    @ViewBuilder
    func minAffection(evolutionDetail: EvolutionDetail) -> some View {
        if let minAffection = evolutionDetail.minAffection {
            GridRow {
                Text("Min affection")
                    .gridRowTitleStyle()
                Text("\(minAffection)")
            }
        }
    }
    
    @ViewBuilder
    func needsOverworldRain(evolutionDetail: EvolutionDetail) -> some View {
        if evolutionDetail.needsOverworldRain {
            GridRow {
                Text("Needs overworld rain")
                    .gridRowTitleStyle()
                Text("Yes")
            }
        }
    }
    
    @ViewBuilder
    func partySpecies(evolutionDetail: EvolutionDetail) -> some View {
        if let partySpecies = evolutionDetail.partySpecies {
            GridRow {
                Text("Party species")
                    .gridRowTitleStyle()
                Text(viewModel.localizedPartySpeciesName)
            }
            .task {
                await viewModel.getPartySpecies(named: partySpecies.name)
            }
        }
    }
    
    @ViewBuilder
    func partyType(evolutionDetail: EvolutionDetail) -> some View {
        if let partyType = evolutionDetail.partyType {
            GridRow {
                Text("Party Type")
                    .gridRowTitleStyle()
                PokemonTypeTag(namedAPIResource: partyType)
            }
        }
    }
    
    @ViewBuilder
    func relativePhysicalStats(evolutionDetail: EvolutionDetail) -> some View {
        if let relativePhysicalStats = evolutionDetail.relativePhysicalStats {
            GridRow {
                Text("Stats")
                    .gridRowTitleStyle()
                switch relativePhysicalStats {
                case -1: Text("Attack < Defense")
                case 0: Text("Attack = Defense")
                case 1: Text("Attack > Defense")
                default: Text("Error")
                }
            }
        }
    }
    
    @ViewBuilder
    func timeOfDay(evolutionDetail: EvolutionDetail) -> some View {
        if !evolutionDetail.timeOfDay.isEmpty {
            GridRow {
                Text("Time of day")
                    .gridRowTitleStyle()
                Text(evolutionDetail.timeOfDay.localizedCapitalized)
            }
        }
    }
    
    @ViewBuilder
    func tradeSpecies(evolutionDetail: EvolutionDetail) -> some View {
        if let tradeSpecies = evolutionDetail.tradeSpecies {
            GridRow {
                Text("Trade species")
                    .gridRowTitleStyle()
                Text(viewModel.localizedTradeSpeciesName)
            }
            .task {
                await viewModel.getTradeSpecies(named: tradeSpecies.name)
            }
        }
    }
    
    @ViewBuilder
    func turnUpsideDown(evolutionDetail: EvolutionDetail) -> some View {
        if evolutionDetail.turnUpsideDown {
            GridRow {
                Text("Turn upside down")
                    .gridRowTitleStyle()
                Text("Yes")
            }
        }
    }
    
}

struct EvolutionDetailRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ForEach(EvolutionChain.example.chain.evolvesTo.first?.evolutionDetails ?? [], id: \.self) { evolutionDetail in
                EvolutionDetailRow(evolutionDetail: evolutionDetail)
            }
        }
        .environmentObject(ImageCache())
        .environmentObject(SettingsManager())
    }
}
