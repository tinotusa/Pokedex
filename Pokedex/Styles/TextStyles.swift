//
//  TextStyles.swift
//  Pokedex
//
//  Created by Tino on 14/8/2022.
//

import SwiftUI

struct TextStyles: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Header font style")
                .headerStyle()
            Text("Subheading font style")
                .subHeaderStyle()
            Text("Body font style")
                .bodyStyle()
            Text("Header bar title font style")
                .headerBarTitleStyle()
            Text("Pokemon tag font style")
                .tagStyle()
            Text("Footer font style")
                .footerStyle()
        }
    }
}

extension View {
    func headerStyle() -> some View {
        self
            .font(.system(size: 40, weight: .regular))
    }
    
    func headerBarTitleStyle() -> some View {
        self
            .font(.system(size: 16).weight(.light))
    }
        
    func bodyStyle() -> some View {
        self
            .font(.system(size: 20, weight: .light))
    }
    
    func subHeaderStyle() -> some View {
        self
            .font(.system(size: 24, weight: .regular))
    }
    
    func footerStyle() -> some View {
        self
            .font(.system(size: 12, weight: .light))
    }
    
    func tagStyle() -> some View {
        self
            .font(.system(size: 14, weight: .regular))
    }
}

struct TextStyles_Previews: PreviewProvider {
    static var previews: some View {
        TextStyles()
    }
}
