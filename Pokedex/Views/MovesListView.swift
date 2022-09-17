//
//  MovesListView.swift
//  Pokedex
//
//  Created by Tino on 15/9/2022.
//

import SwiftUI

struct MovesListView: View {
    let title: String
    let id: Int
    let description: String
    let moveURLS: [URL]
    
    @StateObject private var viewModel = MovesListViewViewModel()
    @EnvironmentObject private var settingsManager: SettingsManager
    @State private var path = NavigationPath()
    
    var body: some View {
        VStack {
            HeaderBar() {
                
            }
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading) {
                    HeaderWithID(title: title, id: id)
                    
                    Text(description)
                    Divider()
                    
                    switch viewModel.viewState {
                    case .loading:
                        LoadingView()
                            .task {
                                await viewModel.loadData(moveURLS: moveURLS, settings: settingsManager.settings)
                            }
                    case .loaded:
                        movesList
                    case .empty:
                        Text("No moves to show.")
                    case .error(let error):
                        Text(error.localizedDescription)
                    }
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

private extension MovesListView {
    @ViewBuilder
    var movesList: some View {
        ForEach(viewModel.sortedMoves) { move in
            NavigationLink {
                MoveDetail(move: move)
            } label: {
                MoveCard(move: move)
            }
        }
        
        if viewModel.hasNextPage {
            ProgressView()
                .task {
                    await viewModel.getNextPage()
                }
        }
    }
}

struct MovesListView_Previews: PreviewProvider {
    static var previews: some View {
        MovesListView(
            title: "Test title",
            id: 123,
            description: "some description here",
            moveURLS: []
        )
        .environmentObject(SettingsManager())
    }
}
