//
//  Pokemon.swift
//  Pokedex
//
//  Created by Blake Andrew Price on 11/10/19.
//  Copyright © 2019 Blake Andrew Price. All rights reserved.
//

import Foundation

struct Pokemon: Codable {
    let id: Int
    let name: String
    let abilities: [Ability]
    let types: [PokeType]
    let sprites: Sprites
}

struct Ability: Codable {
    let ability: NamedAPIResource
    
}

struct PokeType: Codable {
    let type: NamedAPIResource
}

struct Sprites: Codable {
    let front_default: String
}

struct NamedAPIResource: Codable {
    let name: String
}
