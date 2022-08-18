//
//  EnvironmentValues+SearchText.swift
//  Pokedex
//
//  Created by Tino on 17/8/2022.
//

import SwiftUI

struct SearchText: EnvironmentKey {
    static let defaultValue: String = ""
}

extension EnvironmentValues {
    var searchText: String {
        get { self[SearchText.self] }
        set { self[SearchText.self] = newValue }
    }
}

extension View {
    func setSearchText(_ text: String) -> some View {
        environment(\.searchText, text)
    }
}
