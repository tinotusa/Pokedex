//
//  Cachable.swift
//  Pokedex
//
//  Created by Tino on 4/8/2022.
//

import Foundation

protocol Cachable {
    var filename: String { get }
    func getData() -> Data?
}
