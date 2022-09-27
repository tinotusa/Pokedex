//
//  MoveDamageClassDetail.swift
//  Pokedex
//
//  Created by Tino on 23/9/2022.
//

import SwiftUI

struct MoveDamageClassDetail: View {
    let moveDamageClass: MoveDamageClass
    @StateObject private var viewModel = MoveDamageClassDetailViewModel()
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        VStack {
            HeaderBar {
                
            }
            switch viewModel.viewState {
            case .loading:
                ProgressView()
                    .task {
                        viewModel.loadData(moveDamageClass: moveDamageClass, settings: settingsManager.settings)
                    }
            case .loaded:
                damageClassView
            case .empty:
                NoDataView(text: "No data to load.")
            case .error(let error):
                ErrorView(text: error.localizedDescription)
            }
            
        }
        .padding()
        .bodyStyle()
        .foregroundColor(.textColour)
        .backgroundColour()
        .toolbar(.hidden)
    }
}

private extension MoveDamageClassDetail {
    var damageClassView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HeaderWithID(title: viewModel.localizedDamageClassName, id: moveDamageClass.id)
                
                Text(viewModel.localizedDescription)
                
                Divider()
                
                infoGrid
            }
        }
    }
    
    var infoGrid: some View {
        Grid {
            GridRow {
                Text("Moves")
                    .gridRowTitleStyle()
                HStack {
                    Text("\(moveDamageClass.moves.count)")
                    Spacer()
                    if !moveDamageClass.moves.isEmpty {
                        NavigationLink {
                            MovesListView(
                                title: viewModel.localizedDamageClassName,
                                id: moveDamageClass.id,
                                description: "Moves that have this damge class.",
                                moveURLS: moveDamageClass.moves.map { $0.url }
                            )
                        } label: {
                            ShowMoreButton()
                        }
                    }
                }
            }
        }
    }
}

struct MoveDamageClassDetail_Previews: PreviewProvider {
    static var previews: some View {
        MoveDamageClassDetail(moveDamageClass: .example)
            .environmentObject(SettingsManager())
    }
}
