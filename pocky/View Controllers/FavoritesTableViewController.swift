//
//  FavoritesTableViewController.swift
//  pocky
//
//  Created by Nathan Chan on 8/31/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    private var viewModel: MealPlansViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = MealPlansViewModel(networkProvider: NetworkProvider())
        viewModel.didGetSavedMealPlans = { [weak self] _ in
            self?.didGetSavedMealPlans()
        }
        
        viewModel.getSavedMealPlans()
    }
    
    func didGetSavedMealPlans() {
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.mealPlans.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let mealPlanCell = tableView.dequeueReusableCell(withIdentifier: "mealPlanCell", for: indexPath) as? MealPlanTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealPlanTableViewCell.")
        }
        mealPlanCell.mealPlanTitleLabel.text = viewModel.mealPlans[indexPath.row].title
        return mealPlanCell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
