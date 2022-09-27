//
//  HeaderWithID.swift
//  Pokedex
//
//  Created by Tino on 4/9/2022.
//

import SwiftUI

struct HeaderWithID: View {
    let title: String
    var id: Int?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .lineLimit(2)
                Spacer()
                if id != nil {
                    Text(formattedID)
                        .fontWeight(.ultraLight)
                }
            }
            Divider()
        }
        .headerStyle()
        .foregroundColor(.textColour)
    }
    
    var formattedID: String {
        if let id {
            return String(format: "#%03d", id)
        }
        return ""
    }
}

struct HeaderWithID_Previews: PreviewProvider {
    static var previews: some View {
        HeaderWithID(title: "Hello world", id: 23)
    }
}
