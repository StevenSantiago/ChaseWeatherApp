//
//  SearchBarView.swift
//  ChaseWeatherApp
//
//  Created by Steven Santiago on 4/3/23.
//

import UIKit

class SearchBarView: UIView {

    let searchBar = UISearchBar()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSearchBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpSearchBar() {
        addSubview(searchBar)
        searchBar.placeholder = "Enter City"
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }

}
