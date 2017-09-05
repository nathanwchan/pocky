//
//  DishViewModel.swift
//  pocky
//
//  Created by Nathan Chan on 9/4/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

class DishViewModel {
    //MARK: - Properties
    private(set) var dish: Dish?
    let networkProvider: Network!
    
    init(networkProvider: Network) {
        self.networkProvider = networkProvider
    }
    
    //MARK: - Events
    var didGetDish: ((DishViewModel) -> Void)?
    var didCreateDish: ((DishViewModel, String) -> Void)?
    
    //MARK: - Private
    private func didGetDish(dish: Dish?) {
        self.dish = dish
        self.didGetDish?(self)
    }
    
    private func didCreateDish(dishId: String) {
        self.didCreateDish?(self, dishId)
    }
    
    //MARK: - Actions
    func getDish(id: String) {
        networkProvider.getDish(id: id, completion: self.didGetDish)
    }
    
    func updateDish(dish: Dish) {
        networkProvider.updateDish(dish: dish)
    }
    
    func createDish(dish: Dish) {
        networkProvider.createDish(dish: dish, completion: self.didCreateDish)
    }
}

