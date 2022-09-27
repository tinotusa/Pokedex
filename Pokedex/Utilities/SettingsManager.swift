//
//  SettingsManager.swift
//  Pokedex
//
//  Created by Tino on 9/8/2022.
//

import SwiftUI

@dynamicMemberLookup
final class SettingsManager: ObservableObject {
    @Published var settings: Settings = Settings() {
        didSet {
            saveSettings()
        }
    }
    @AppStorage("appSettings") var appSettings = Data()
    
    init() {
        load()
    }
    
    subscript<T>(dynamicMember keyPath: WritableKeyPath<Settings, T>) -> T {
        get { settings[keyPath: keyPath] }
        set { settings[keyPath: keyPath] = newValue }
    }
    
    private func load() {
        do {
            if appSettings.isEmpty {
                print("settings are empty")
                settings = .default
                return
            }
            print("=========== about to load settings ===========")
            settings = try JSONDecoder().decode(Settings.self, from: appSettings)
            print(settings)
            print("=========== loaded settings ===========")
        } catch {
            print("Error in \(#function).\n\(error)")
        }
    }
    
    static func load(from appSettingsData: Data) -> Settings? {
        do {
            return try JSONDecoder().decode(Settings.self, from: appSettingsData)
        } catch {
            print("Error in \(#function).\n\(error)")
        }
        return nil
    }
    
    private func saveSettings() {
        do {
            appSettings = try JSONEncoder().encode(settings)
            print("=========== settings got saved ===========")
            print(settings)
            print("=========== settings got saved ===========")
        } catch {
            print("Error in \(#function).\n\(error)")
        }
    }
}
