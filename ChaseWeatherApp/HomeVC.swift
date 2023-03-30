//
//  HomeVC.swift
//  ChaseWeatherApp
//
//  Created by Steven Santiago on 3/29/23.
//

import UIKit

class HomeVC: UIViewController {
    
    let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        setUpSearchBar()
        // Do any additional setup after loading the view.
    }
    
    private func setUpSearchBar() {
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.placeholder = "Enter City"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }


}

//TODO: AutoComplete Cities might be nice feature at the end, this prevents user from mistyping city and not finding a valid result

extension HomeVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Retrieving weather for location!")
        guard let userInput = searchBar.text else {
            return
        }
        
        print("City weather for \(userInput) being retrieved!")
    }
}

