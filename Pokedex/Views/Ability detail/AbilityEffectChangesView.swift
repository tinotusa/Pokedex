//
//  AbilityEffectChangesView.swift
//  Pokedex
//
//  Created by Tino on 4/9/2022.
//

import SwiftUI

struct AbilityEffectChangesView: View {
    @ObservedObject var viewModel: AbilityDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HeaderBar() {
                
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    if let ability = viewModel.ability {
                        HeaderWithID(
                            title: viewModel.localizedAbilityName,
                            id: ability.id
                        )
                    }
                    
                    Text("Ability changes.")
                    
                    Divider()
                    
                    effectChangesGrid
                    
                    Spacer()
                }
            }
        }
        .padding()
        .bodyStyle()
        .foregroundColor(.textColour)
        .backgroundColour()
        .toolbar(.hidden)
    }
}

private extension AbilityEffectChangesView {
    var effectChangesGrid: some View {
        Grid(alignment: .leadingFirstTextBaseline, verticalSpacing: 6) {
            GridRow(alignment: .center) {
                Text("Game")
                Text("Change")
            }
            .fontWeight(.regular)
            
            ForEach(
                viewModel.effectChanges,
                id: \.effectChange
            ) { versionGroup, effectChange in
                GridRow {
                    Text(versionGroup)
                        .gridRowTitleStyle()
                    Text(effectChange)
                }
            }
        }
    }
}

struct AbilityEffectChangesView_Previews: PreviewProvider {
    static var viewModel = {
        let vm = AbilityDetailViewModel()
        Task {
            await vm.loadData(ability: .example, settings: .default)
        }
        return vm
    }()
    
    static var previews: some View {
        AbilityEffectChangesView(viewModel: viewModel)
    }
}
