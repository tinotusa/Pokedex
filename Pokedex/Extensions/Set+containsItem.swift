//
//  Set+containsItem.swift
//  Pokedex
//
//  Created by Tino on 21/8/2022.
//

import Foundation


extension Set where Element: Identifiable & Nameable, Element.ID == Int {
    /// Returns true if the set contains an item that has the given name
    ///
    /// - parameter name: The string to search in the set.
    /// - returns: `true` if the name was found in the set.
    func containsItem(named name: String) -> Bool {
        if let id = Int(name) {
            if self.contains(where: { $0.id == id }) {
                return true
            }
        }
        if self.contains(where: { $0.name.contains(name) }) {
            return true
        }
        return false
    }
    
    /// Returns true if the set contains an item that has the given id
    ///
    /// - parameter id: The int to search in the set.
    /// - returns: `true` if the id was found in the set.
    func contains(id: Int) -> Bool {
        containsItem(named: "\(id)")
    }
}
