//
//  Environment+AppSettings.swift
//  Pokedex
//
//  Created by Tino on 19/8/2022.
//

import SwiftUI

struct AppSettingsKey: EnvironmentKey {
    static let defaultValue = Settings.default
}

extension EnvironmentValues {
    var appSettings: Settings {
        get { self[AppSettingsKey.self] }
        set { self[AppSettingsKey.self] = newValue }
    }
}

extension View {
    func setSettings(_ settings: Settings) -> some View {
        environment(\.appSettings, settings)
    }
}
