//
//  TabBar.swift
//  Pokedex
//
//  Created by Tino on 22/8/2022.
//

import SwiftUI

// TODO: Figure out how to center a scrollview horizontally.
struct TabBar<T>: View
where T: Identifiable & CaseIterable & RawRepresentable,
      T.RawValue == String, T.AllCases == [T]
{
    var tabs: T.Type
    @Binding var selectedTab: T
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(T.allCases) { tab in
                    Button {
                        selectedTab = tab
                    } label: {
                        TabButton(tab: tab, isSelected: isSelected(tab))
                    }
                }
            }
        }
    }
    
    func isSelected(_ tab: T) -> Bool {
        selectedTab == tab
    }
}

extension TabBar {
    struct TabButton: View {
        let tab: T
        let isSelected: Bool
        
        var body: some View {
            Text(tab.rawValue.capitalized)
                .padding(.horizontal)
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(isSelected ? Color.selectedTabColour : Color.unselectedTabColour)
                .cornerRadius(24)
        }
    }
}
struct TabBar_Previews: PreviewProvider {
    enum TestTabs: String, CaseIterable, Identifiable {
        case one, two, three
        var id: Self { self }
    }
    
    static var previews: some View {
        TabBar(tabs: TestTabs.self, selectedTab: .constant(.one))
    }
}
