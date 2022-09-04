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
            PopoverNavigationBar()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    HeaderWithID(
                        title: viewModel.localizedAbilityName,
                        id: viewModel.ability.id
                    )
                    
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
        vm.setUp(ability: .example, settings: .default)
        Task {
            await vm.loadData()
        }
        return vm
    }()
    
    static var previews: some View {
        AbilityEffectChangesView(viewModel: viewModel)
    }
}
