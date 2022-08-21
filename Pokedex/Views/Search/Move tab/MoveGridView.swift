//
//  MoveGridView.swift
//  Pokedex
//
//  Created by Tino on 19/8/2022.
//

import SwiftUI

struct MoveGridView: View {
    @EnvironmentObject private var viewModel: MoveGridViewViewModel
    @EnvironmentObject private var searchBar: SearchBarViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State private var columns: [GridItem] = [
        .init(.adaptive(minimum: 300))
    ]
    
    var body: some View {
        Group {
            if searchBar.isSearching && viewModel.isLoading {
                loadingView
            } else {
                movesList
            }
        }
//        .navigationDestination(for: Move.self) { move in
//            Text("Move detail page here: \(move.name)")
//        }
        .onReceive(searchBar.$searchText
            .debounce(
                for: 0.8,
                scheduler: RunLoop.main
            )
        ) { searchText in
            Task {
                await viewModel.getMove(searchText: searchText)
            }
        }
        .task {
            if !viewModel.viewHasAppeared {
                await viewModel.getMoves()
                viewModel.viewHasAppeared = true
            }
        }
    }
}

private extension MoveGridView {
    var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
    
    var movesList: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.filteredMoves(searchText: searchBar.sanitizedSearchText)) { move in
                    NavigationLink(destination: Text("Move detail page: \(move.name)")) {
                        MoveCard(move: move)
                    }
                    .buttonStyle(.plain)
                }
                if !searchBar.isSearching && viewModel.hasNextPage && !viewModel.isLoading {
                    ProgressView()
                        .task {
                            print("Here lmao")
                            await viewModel.getNextMovesPage()
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct MoveGridView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MoveGridView()
                .environmentObject(MoveGridViewViewModel())
                .environmentObject(SearchBarViewModel())
        }
    }
}
