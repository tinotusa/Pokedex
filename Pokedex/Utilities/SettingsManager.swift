//
//  SettingsManager.swift
//  Pokedex
//
//  Created by Tino on 9/8/2022.
//

import SwiftUI

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
    
    var shouldCacheResults: Bool {
        get { settings.shouldCacheResults }
        set {
            settings.shouldCacheResults = newValue
            PokeAPI.shared.shouldCacheResults = newValue
        }
    }
    
    var isDarkMode: Bool {
        get { settings.isDarkMode }
        set { settings.isDarkMode = newValue }
    }
    
    
    var language: Language? {
        get { settings.language }
        set { settings.language = newValue }
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
