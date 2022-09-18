//
//  HomeMovesTab.swift
//  Pokedex
//
//  Created by Tino on 19/8/2022.
//

import SwiftUI

struct HomeMovesTab: View {
    @ObservedObject var viewModel: HomeMovesTabViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State private var columns: [GridItem] = [
        .init(.adaptive(minimum: 300))
    ]
    
    var body: some View {
        ScrollView {
            switch viewModel.viewState {
            case .loading:
                LoadingView()
                    .task {
                        await viewModel.getMoves()
                    }
            case .loaded:
                if viewModel.searchState == .searching && viewModel.filteredMoves.isEmpty {
                    LoadingView(text: "Searching")
                } else if viewModel.searchState == .error {
                    SearchErrorView()
                } else {
                    movesList
                }
            case .error(let error):
                ErrorView(text: error.localizedDescription)
            case .empty:
                Text("Empty")
            }
        }
    }
}

private extension HomeMovesTab {
    var movesList: some View {
        LazyVGrid(columns: columns) {
            ForEach(viewModel.filteredMoves) { move in
                NavigationLink{
                    MoveDetail(move: move)
                } label: {
                    MoveCard(move: move)
                }
                .buttonStyle(.plain)
            }
            if viewModel.hasNextPage && viewModel.searchState == .idle {
                ProgressView()
                    .task {
                        await viewModel.getNextMovesPage()
                    }
            }
        }
        .padding(.horizontal)
    }
}

struct HomeMovesTab_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeMovesTab(viewModel: HomeMovesTabViewModel())
                .environmentObject(ImageCache())
        }
    }
}
