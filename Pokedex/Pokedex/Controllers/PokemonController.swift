//
//  PokemonController.swift
//  Pokedex
//
//  Created by Blake Andrew Price on 11/10/19.
//  Copyright © 2019 Blake Andrew Price. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
}

class PokemonController: Codable {
    //MARK: - Properties
    var arrayOfPokemon: [Pokemon] = []
    private let baseUrl = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
    
    //MARK: - Functions
    func fetchPokemon(for pokemonName: String, completion: @escaping (Result<Pokemon, NetworkError>) -> Void) {
        let pokemonUrl = baseUrl.appendingPathComponent("\(pokemonName)")
        
        var request = URLRequest(url: pokemonUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error receiving Pokemon (\(pokemonName)) details: \(error)")
                completion(.failure(.otherError))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            print(String(decoding: data, as: UTF8.self))
            let decoder = JSONDecoder()
            do {
                let decodedPokemon = try decoder.decode(Pokemon.self, from: data)
                completion(.success(decodedPokemon))
            } catch {
                print("Error decoding Pokemon object: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    //MARK: - Persistence
    private var pokemonListURL: URL? {
        let fileManager = FileManager.default
        guard let documents = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            else { return nil }
        
        return documents.appendingPathComponent("savedpokemon.plist")
    }
    
    func saveToPersistentStore() {
        guard let url = pokemonListURL else { return }
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(arrayOfPokemon)
            try data.write(to: url)
        } catch {
            print("Error saving Pokemon data: \(error)")
        }
    }
    
    func loadFromPersistentStore() {
        guard let url = pokemonListURL else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            let decodedPokemon = try decoder.decode([Pokemon].self, from: data)
            arrayOfPokemon = decodedPokemon
        } catch  {
            print("Error loading Pokemon data: \(error)")
        }
    }
    
    func deletePokemon(pokemon: Pokemon) {
        if let index = arrayOfPokemon.firstIndex(of: pokemon) {
            arrayOfPokemon.remove(at: index)
        }
        saveToPersistentStore()
    }
    
    func sortPokemon(byId: Bool) {
        if byId {
            arrayOfPokemon.sort { (lhs, rhs) -> Bool in
                return lhs.id < rhs.id
            }
        } else {
            arrayOfPokemon.sort { (lhs, rhs) -> Bool in
                return lhs.name < rhs.name
            }
        }
    }
    
    func fetchImage(at urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        let imageUrl = URL(string: urlString)!
        
        var request = URLRequest(url: imageUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let image = UIImage(data: data)!
            completion(.success(image))
        }.resume()
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
