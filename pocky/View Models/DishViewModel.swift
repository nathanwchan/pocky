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
    
    //MARK: - Private
    private func didGetDish(dish: Dish?) {
        self.dish = dish
        self.didGetDish?(self)
    }
    
    //MARK: - Actions
    func getDish(id: String) {
        networkProvider.getDish(id: id, completion: self.didGetDish)
    }
    
    func saveDish(dish: Dish) {
        networkProvider.saveDish(dish: dish)
    }
}

