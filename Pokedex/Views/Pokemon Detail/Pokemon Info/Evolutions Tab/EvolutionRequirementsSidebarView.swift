//
//  EvolutionRequirementsSidebarView.swift
//  Pokedex
//
//  Created by Tino on 30/7/2022.
//

import SwiftUI

struct EvolutionRequirementsSidebarView: View {
    @StateObject private var viewModel: EvolutionRequirementsSidebarViewViewModel
    
    init(evolutionDetail: EvolutionDetail) {
        _viewModel = StateObject(wrappedValue: EvolutionRequirementsSidebarViewViewModel(evolutionDetail: evolutionDetail))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(
                "Trigger: \(viewModel.localizedEvolutionTriggerName ?? "Error")",
                comment: "Trigger is the action that causes the pokemon to evolve."
            )
            Group {
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
                if let knownMoveTypeName = viewModel.localizedKnownMoveType {
                    Text("Move type: \(knownMoveTypeName)")
                }
                if let locationName = viewModel.localizedLocationName {
                    Text("Location: \(locationName)")
                }
                if let minLevel = viewModel.evolutionDetail.minLevel {
                    Text("Min level: \(minLevel)")
                }
                if let minHappiness = viewModel.evolutionDetail.minHappiness {
                    Text("Min happiness: \(minHappiness)")
                }
                if let minBeauty = viewModel.evolutionDetail.minBeauty {
                    Text("Min beauty: \(minBeauty)")
                }
                if let minAffection = viewModel.evolutionDetail.minAffection {
                    Text("Min affection: \(minAffection)")
                }
            }
            Group {
                if viewModel.evolutionDetail.needsOverworldRain {
                    Text("Needs overworld rain.")
                }
                if let partySpeciesName = viewModel.localizedPartySpeciesName {
                    Text("Party must have: \(partySpeciesName)")
                }
                if let partyType = viewModel.localizedPartyTypeName {
                    Text("Party must have type: \(partyType)")
                }
                if let relativePhysicalStats = viewModel.evolutionDetail.relativePhysicalStats {
                    if relativePhysicalStats == 1 {
                        Text("Required stat: Attack > Defense")
                    } else if relativePhysicalStats == 0 {
                        Text("Required stat: Attack = Defense")
                    } else if relativePhysicalStats == -1 {
                        Text("Required stat: Attack < Defense")
                    }
                }
                if let timeOfDay = viewModel.evolutionDetail.timeOfDay, !timeOfDay.isEmpty {
                    Text("Evolve during: \(timeOfDay)")
                }
                if let tradeSpeciesName = viewModel.localizedTradeSpeciesName {
                    Text("Trade: \(tradeSpeciesName)")
                }
                if viewModel.evolutionDetail.turnUpsideDown {
                    Text("Turn 3DS upside down during level up.")
                }
            }
        }
        .task {
            await viewModel.setUp()
        }
    }
}
