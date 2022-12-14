//
//  SettingsView.swift
//  Pokedex
//
//  Created by Tino on 19/8/2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settingsManager: SettingsManager
    @StateObject private var viewModel = SettingsViewViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            
            ScrollView {
                HeaderWithID(title: "Settings")
                    .padding(.horizontal)
                
                switch viewModel.viewState {
                case .loading:
                    LoadingView(text: "Loading languages.")
                        .task {
                            await viewModel.loadData(settings: settingsManager.settings)
                        }
                case .loaded:
                    settingsList
                        .padding(.horizontal)
                default:
                    Text("Empty view")
                }
            }
        }
        .confirmationDialog(
            "Delete cache",
            isPresented: $viewModel.showDeleteCacheConfirmation
        ) {
            Button(role: .destructive) {
                viewModel.deleteCache()
            } label: {
                Text("Delete")
            }
        } message: {
            Text("Are you sure you want to delete the cache?")
        }
        .bodyStyle()
        .foregroundColor(.textColour)
        .backgroundColour()
        .toolbar(.hidden)
    }
}

private extension SettingsView {
    var navigationBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Label("Close", systemImage: "xmark")
            }
            Spacer()
        }
        .padding([.top, .horizontal])
    }
    
    var settingsList: some View {
        VStack {
            Toggle("Dark mode", isOn: $settingsManager.isDarkMode)
            Toggle("Should cache", isOn: $settingsManager.shouldCacheResults)
            HStack {
                Text("Language")
                Spacer()
                Picker("Language", selection: $settingsManager.language) {
                    Text("No selection")
                        .tag(nil as Language?)
                    ForEach(viewModel.languages) { language in
                        Text(language.localizedLanguageName)
                            .tag(language as Language?)
                    }
                }
                .pickerStyle(.menu)
            }
            HStack {
                Text("Cache: \(viewModel.cacheSize.formatted(.byteCount(style: .file)))")
                Spacer()
                Button(action: { viewModel.showDeleteCacheConfirmation = true }) {
                    Label {
                        Text("Delete cache")
                    } icon: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .foregroundColor(.blue)
                }
                .opacity(viewModel.cacheSize == 0 ? 0.5 : 1)
                .disabled(viewModel.cacheSize == 0)
            }
            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsManager())
    }
}
