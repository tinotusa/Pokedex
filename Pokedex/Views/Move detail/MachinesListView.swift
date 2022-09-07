//
//  MachinesListView.swift
//  Pokedex
//
//  Created by Tino on 26/8/2022.
//

import SwiftUI


struct MachinesListView: View {
    @ObservedObject var moveDetailViewModel: MoveDetailViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.appSettings) var appSettings
    
    @StateObject private var viewModel = MachinesListViewViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            PopoverNavigationBar()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    nameAndIDRow
                    
                    Text("Machines that teach this move and the game in which they appear.")
                    
                    Divider()
                    
                    if !viewModel.viewHasAppeared {
                        LoadingView()
                    } else {
                        machinesList
                    }
                }
            }
        }
        .bodyStyle()
        .padding(.horizontal)
        .foregroundColor(.textColour)
        .background {
            Color.backgroundColour
                .ignoresSafeArea()
        }
        .task {
            if !viewModel.viewHasAppeared {
                await viewModel.loadData(machineDetails: moveDetailViewModel.move.machines)
                viewModel.viewHasAppeared = true
            }
        }
    }
}


private extension MachinesListView {
    var machinesList: some View {
        ForEach(viewModel.sortedMachines) { machine in
            HStack {
                if let item = viewModel.itemNamed(machine.item.name) {
                    ImageLoaderView(url: item.sprites.default) {
                        ProgressView()
                    } content: { image in
                        image
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(width: Constants.itemImageSize, height: Constants.itemImageSize)
                    
                    Text(item.names.localizedName(language: appSettings.language, default: "Error"))
                    Spacer()
                    Text(machine.versionGroup.name)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    var nameAndIDRow: some View {
        VStack(spacing: 0) {
            HStack {
                Text(moveDetailViewModel.localizedMoveName)
                Spacer()
                Text(moveDetailViewModel.moveID)
                    .fontWeight(.ultraLight)
            }
            .headerStyle()
            
            Divider()
        }
    }
    
    enum Constants {
        static let itemImageSize = 30.0
    }
}


struct MachinesListView_Previews: PreviewProvider {
    static var viewModel = {
        let vm = MoveDetailViewModel()
        vm.setUp(move: .example, settings: .default)
        Task {
            await vm.loadData()
        }
        return vm
    }()
    
    static var previews: some View {
        MachinesListView(moveDetailViewModel: viewModel)
            .environmentObject(ImageCache())
    }
}
