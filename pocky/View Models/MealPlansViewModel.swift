//
//  MealPlansViewModel.swift
//  pocky
//
//  Created by Nathan Chan on 8/31/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

class MealPlansViewModel {
    //MARK: - Properties
    private(set) var mealPlans = [MealPlan]()
    let networkProvider: Network!
    
    init(networkProvider: Network) {
        self.networkProvider = networkProvider
    }
    
    //MARK: - Events
    var didGetSavedMealPlans: (() -> Void)?
    
    //MARK: - Private
    private func didGetSavedMealPlans(mealPlans: [MealPlan]?) {
        self.mealPlans = mealPlans ?? []
        self.didGetSavedMealPlans?()
    }
    
    //MARK: - Actions
    func getSavedMealPlans() {
        networkProvider.getSavedMealPlans(completion: self.didGetSavedMealPlans)
    }
    
    func deleteMealPlan(mealPlanIndex: Int) {
        guard let mealPlanId = mealPlans[mealPlanIndex].id else {
            return
        }
        networkProvider.deleteMealPlan(mealPlanId: mealPlanId)
    }
}
