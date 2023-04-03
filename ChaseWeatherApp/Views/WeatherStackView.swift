//
//  WeatherStackView.swift
//  ChaseWeatherApp
//
//  Created by Steven Santiago on 4/3/23.
//

import UIKit

class WeatherStackView: UIStackView {

    let tempatureLabel = UILabel()
    let cityLabel = UILabel()
    let weatherDescriptionLabel = UILabel()
    let weatherImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpWeatherViews()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpWeatherViews() {
        axis = .vertical
        alignment = .center
        spacing = 20.0
        translatesAutoresizingMaskIntoConstraints = false

        addArrangedSubview(weatherImageView)
        addArrangedSubview(tempatureLabel)
        addArrangedSubview(weatherDescriptionLabel)
        addArrangedSubview(cityLabel)

        NSLayoutConstraint.activate([
            weatherImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            tempatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherDescriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            cityLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

}
