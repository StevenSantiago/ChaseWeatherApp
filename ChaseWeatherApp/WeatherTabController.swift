//
//  WeatherTabController.swift
//  ChaseWeatherApp
//
//  Created by Steven Santiago on 3/29/23.
//

import UIKit

class WeatherTabController: UITabBarController {
    
    override func viewDidLoad() {
        setUpTabController()
    }
    
    func setUpTabController() {
        let homeVC = HomeVC(weatherService: WeatherService())
        
        let homeTabBar = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        homeVC.tabBarItem = homeTabBar
        
        let settingVC = SettingsVC()
        let settingTabBar = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)
        settingVC.tabBarItem = settingTabBar
        
        tabBar.backgroundColor = .white
        viewControllers = [homeVC,settingVC]
    }
}
