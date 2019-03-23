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
    private var seenDishes: Set<Dish> = []
    
    init(networkProvider: Network = NetworkProvider()) {
        networkProvider.getAllDishes(completion: self.didGetAllDishes)
    }
    
    //MARK: - Events
    var didGetAllDishes: (() -> Void)?
    
    //MARK: - Private
    private func didGetAllDishes(dishes: [Dish]?) {
        self.allDishes = dishes
        self.didGetAllDishes?()
    }

    func getNewUnseenDish(with categories: [Category]) -> Dish? {
        guard let allDishes = allDishes else { return nil }

        var unseenDishes = Set(allDishes).subtracting(seenDishes)
        var newUnseenDishOptional = unseenDishes.filter({ Set($0.category).isSubset(of: Set(categories)) }).randomElement()
        if newUnseenDishOptional == nil  {
            seenDishes = seenDishes.filter {
                !Set($0.category).elementsEqual(Set(categories))
            }
            unseenDishes = Set(allDishes).subtracting(seenDishes)
            newUnseenDishOptional = unseenDishes.filter({ Set($0.category).isSubset(of: Set(categories)) }).randomElement()
        }
        guard let newUnseenDish = newUnseenDishOptional else { return nil }
        seenDishes.insert(newUnseenDish)

        return newUnseenDish
    }
}
