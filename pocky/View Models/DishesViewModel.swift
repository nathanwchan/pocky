//
//  DishesViewModel.swift
//  pocky
//
//  Created by Nathan Chan on 8/31/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

class DishesViewModel {
    //MARK: - Properties
    private(set) var allDishes: [Dish]?
    
    init(networkProvider: Network) {
        networkProvider.getAllDishes(completion: self.didGetAllDishes)
    }
    
    //MARK: - Events
    var didGetAllDishes: ((DishesViewModel) -> Void)?
    
    //MARK: - Private
    private func didGetAllDishes(dishes: [Dish]?) {
        self.allDishes = dishes
        self.didGetAllDishes?(self)
    }
}
