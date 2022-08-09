//
//  Settings.swift
//  Pokedex
//
//  Created by Tino on 9/8/2022.
//

import Foundation

struct Settings: Codable, Hashable {
    var shouldCacheResults = true
    var language: Language? = nil
    var isDarkMode = false
    
    static var `default`: Settings {
        Settings()
    }
}
