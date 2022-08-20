//
//  MoveGridView.swift
//  Pokedex
//
//  Created by Tino on 19/8/2022.
//

import SwiftUI

struct MoveGridView: View {
    @Environment(\.searchText) var searchText
    @EnvironmentObject private var viewModel: MoveGridViewViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State private var columns: [GridItem] = [
        .init(.adaptive(minimum: 300))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.filteredMoves(searchText: searchText)) { move in
                    NavigationLink(value: move) {
                        MoveCard(move: move)
                    }
                    .buttonStyle(.plain)
                }
                if searchText.isEmpty && viewModel.hasNextPage && !viewModel.isLoading {
                    ProgressView()
                        .task {
                            print("Here lmao")
                            await viewModel.getNextMovesPage()
                        }
                }
            }
            .padding(.horizontal)
        }
        .navigationDestination(for: Move.self) { move in
            Text("Move detail page here: \(move.name)")
        }
        .task {
            if !viewModel.viewHasAppeared {
                await viewModel.getMoves()
                viewModel.viewHasAppeared = true
            }
        }
    }
}

struct MoveGridView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MoveGridView()
                .environmentObject(MoveGridViewViewModel())
        }
    }
}
