//
//  MoveDetail+MachinesListViewViewModel.swift
//  Pokedex
//
//  Created by Tino on 31/8/2022.
//

import Foundation

extension MoveDetail {
    @MainActor
    final class MachinesListViewViewModel: ObservableObject {
        @Published private(set) var items = [Item]()
        @Published private(set) var machines = [Machine]()
        @Published var viewHasAppeared = false
    }
}

extension MoveDetail.MachinesListViewViewModel {
    func loadData(machineDetails: [MachineVersionDetail]) async {
        await getMachines(machineDetails: machineDetails)
        await getItems(machines: self.machines)
    }
    
    func getMachines(machineDetails: [MachineVersionDetail]) async {
        await withTaskGroup(of: Machine?.self) { @MainActor group in
            for machine in machineDetails {
                group.addTask {
                    let item = try? await PokeAPI.shared.getData(for: Machine.self, url: machine.machine.url)
                    return item
                }
            }
            var tempItems = [Machine]()
            for await machine in group {
                if let machine {
                    tempItems.append(machine)
                }
            }
            machines.append(contentsOf: tempItems)
        }
    }
    
    func getItems(machines: [Machine]) async {
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
