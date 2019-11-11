//
//  PokemonTableViewController.swift
//  Pokedex
//
//  Created by Blake Andrew Price on 11/10/19.
//  Copyright © 2019 Blake Andrew Price. All rights reserved.
//

import UIKit

class PokemonTableViewController: UITableViewController {
    //MARK: - Properties
    var pokemonController = PokemonController()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonController.loadFromPersistentStore()
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonController.arrayOfPokemon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        cell.textLabel?.text = pokemonController.arrayOfPokemon[indexPath.row].name
        
        return cell
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchSegue" {
            if let searchVC = segue.destination as? PokemonDetailViewController {
                searchVC.pokemonController = pokemonController
            }
        } else if segue.identifier == "DetailSegue" {
            if let detailVC = segue.destination as? PokemonDetailViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    detailVC.pokemon = pokemonController.arrayOfPokemon[indexPath.row]
                }
                detailVC.pokemonController = pokemonController
            }
        }
    }
}
