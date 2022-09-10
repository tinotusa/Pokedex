//
//  ViewState.swift
//  Pokedex
//
//  Created by Tino on 9/9/2022.
//

import Foundation

enum ViewState {
    case loading
    case loaded
    case empty
    case error(Error)
}
