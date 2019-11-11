//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Blake Andrew Price on 11/10/19.
//  Copyright © 2019 Blake Andrew Price. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController /*UISearchBarDelegate*/ {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spriteImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var abilityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var pokemonController: PokemonController!
    var pokemon: Pokemon?
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchResultsController.performSearch(searchTerm: searchBarText, resultType: resultType) { (error) in
//            if let error = error {
//                print(error)
//            } else {
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        }
//    }
    
    
    func updateViews() {
        if let pokemon = pokemon {
            nameLabel.text = pokemon.name
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
