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
    @EnvironmentObject private var settingsManager: SettingsManager
    
    @StateObject private var viewModel = MachinesListViewViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            PopoverNavigationBar()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    HeaderWithID(title: moveDetailViewModel.localizedMoveName, id: moveDetailViewModel.moveID)
                    
                    Text("Machines that teach this move and the game in which they appear.")
                    
                    Divider()
                    
                    switch viewModel.viewState {
                    case .loading:
                        LoadingView()
                            .task {
                                await viewModel.loadData(machineDetails: moveDetailViewModel.move?.machines)
                            }
                    case .loaded:
                        machinesList
                    case .error(let error):
                        Text(error.localizedDescription)
                    case .empty:
                        Text("Empty")
                    }
                }
            }
        }
        .bodyStyle()
        .padding(.horizontal)
        .foregroundColor(.textColour)
        .backgroundColour()
        .preferredColorScheme(settingsManager.isDarkMode ? .dark : .light)
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
                    
                    Text(item.names.localizedName(language: settingsManager.language, default: "Error"))
                    Spacer()
                    Text(machine.versionGroup.name)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    enum Constants {
        static let itemImageSize = 30.0
    }
}


struct MachinesListView_Previews: PreviewProvider {
    static var viewModel = {
        let vm = MoveDetailViewModel()
        Task {
            await vm.loadData(move: .example, settings: .default)
        }
        return vm
    }()
    
    static var previews: some View {
        MachinesListView(moveDetailViewModel: viewModel)
            .environmentObject(ImageCache())
            .environmentObject(SettingsManager())
    }
}
