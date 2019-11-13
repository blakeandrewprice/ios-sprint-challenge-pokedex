//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Blake Andrew Price on 11/10/19.
//  Copyright © 2019 Blake Andrew Price. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spriteImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var abilityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        let tap = UITapGestureRecognizer(target: self.view,
                                         action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    var pokemonController: PokemonController!
    var pokemon: Pokemon?
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        if let searchTerm = searchBar.text?.lowercased() {
            pokemonController.fetchPokemon(for: searchTerm) { (result) in
                if let pokemon = try? result.get() {
                    DispatchQueue.main.async {
                        self.pokemon = pokemon
                        self.updateViews()
                    }
                }
            }
        }
    }
    
    
    func updateViews() {
        if let pokemon = pokemon {
            nameLabel.text = pokemon.name.capitalized
            idLabel.text = String(pokemon.id)
            typeLabel.text = pokemon.types.map({ (types) -> String in
                return types.type.name.capitalized
                }).joined(separator: ", ")
            abilityLabel.text = pokemon.abilities.map({ (abilities) -> String in
                return abilities.ability.name.capitalized
            }).joined(separator: ", ")
            pokemonController.fetchImage(at: pokemon.sprites.front_default) { (result) in
                if let image = try? result.get() {
                    DispatchQueue.main.async {
                        self.spriteImageView.image = image
                    }
                }
            }
        }
    }
}
