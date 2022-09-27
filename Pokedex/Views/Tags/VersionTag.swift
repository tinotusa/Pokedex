//
//  VersionTag.swift
//  Pokedex
//
//  Created by Tino on 22/9/2022.
//

import SwiftUI

final class VersionTagViewModel: ObservableObject {
    @Published private var settings: Settings?
    @Published private var version: Version?
    
    func setUp(version: Version, settings: Settings) {
        self.version = version
        self.settings = settings
    }
    
    var localizedVersionName: String {
        guard let settings else { return "Error1" }
        guard let version else { return "Error2" }
        return version.names.localizedName(language: settings.language, default: version.name)
    }
}

struct VersionTag: View {
    let version: Version
    
    @StateObject private var viewModel = VersionTagViewModel()
    @EnvironmentObject private var settingsManager: SettingsManager
    
    var body: some View {
        Text(viewModel.localizedVersionName)
            .task {
                viewModel.setUp(version: version, settings: settingsManager.settings)
            }
    }
}

struct VersionTag_Previews: PreviewProvider {
    static var previews: some View {
        VersionTag(version: .example)
            .environmentObject(SettingsManager())
    }
}
