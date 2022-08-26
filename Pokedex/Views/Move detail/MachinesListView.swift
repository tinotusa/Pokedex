//
//  MachinesListView.swift
//  Pokedex
//
//  Created by Tino on 26/8/2022.
//

import SwiftUI

@MainActor
final class MachinesListViewViewMode: ObservableObject {
    @Published private(set) var items = [Item]()
}

extension MachinesListViewViewMode {
    func loadData(machines: [Machine]) async {
        await withTaskGroup(of: Item?.self) { @MainActor group in
            for machine in machines {
                group.addTask {
                    let item = try? await Item.from(name: machine.item.name)
                    return item
                }
            }
            var tempItems = [Item]()
            for await item in group {
                if let item {
                    tempItems.append(item)
                }
            }
            items.append(contentsOf: tempItems)
        }
    }
    
    func itemNamed(_ name: String) -> Item? {
        return items.first { $0.name == name }
    }
}

struct MachinesListView: View {
    @ObservedObject var moveDetailViewModel: MoveDetailViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.appSettings) var appSettings
    
    @StateObject private var viewModel = MachinesListViewViewMode()
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                headerBar
                HStack {
                    Text(moveDetailViewModel.localizedMoveName)
                    Spacer()
                    Text(moveDetailViewModel.moveID)
                        .fontWeight(.ultraLight)
                }
                .headerStyle()
                
                Divider()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        ForEach(moveDetailViewModel.machines) { machine in
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
                                    .frame(width: Constants.itemImageSize)
                                    
                                    Text(item.names.localizedName(language: appSettings.language, default: "Error"))
                                    Spacer()
                                    Text(machine.versionGroup.name)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
            }
            .bodyStyle()
            .foregroundColor(.textColour)
            .padding(.horizontal)
            .task {
                await viewModel.loadData(machines: moveDetailViewModel.machines)
        }
        }
    }
}

private extension MachinesListView {
    var headerBar: some View {
        HStack {
            Button {
                DispatchQueue.main.async {
                    dismiss()
                }
            } label: {
                Label("Close", systemImage: "xmark")
            }
            Spacer()
        }
    }
    
    enum Constants {
        static let itemImageSize = 30.0
    }
}


//struct MachinesListView_Previews: PreviewProvider {
//    static var previews: some View {
////        MachinesListView(moveDetailViewModel: MoveDetailViewModel())
//    }
//}
