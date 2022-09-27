//
//  GridRowItem.swift
//  Pokedex
//
//  Created by Tino on 23/8/2022.
//

import SwiftUI

struct GridRowItem<Content: View>: View {
    let title: LocalizedStringKey
    let content: () -> Content
    var comment: StaticString? = nil
    
    init(title: LocalizedStringKey, @ViewBuilder content: @escaping () -> Content, comment: StaticString? = nil) {
        self.title = title
        self.content = content
        self.comment = comment
    }
    
    var body: some View {
        GridRow {
            Text(title, comment: comment)
                .foregroundColor(.gray)
            content()
        }
        .bodyStyle()
    }
}

struct GridRowItem_Previews: PreviewProvider {
    static var previews: some View {
        GridRowItem(title: "Title") { Text("hello world") }
    }
}
