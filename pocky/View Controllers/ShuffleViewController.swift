//
//  ShuffleViewController.swift
//  pocky
//
//  Created by Nathan Chan on 8/21/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

class ShuffleViewController: UIViewController {

    private var viewModel: MealsViewModel?
    private let stackView = UIStackView(frame: .zero)
    private let mealsStackView = UIStackView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initViewModel()
        
        view.backgroundColor = .white
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        
        view.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        
        mealsStackView.translatesAutoresizingMaskIntoConstraints = false
        mealsStackView.axis = .vertical
        mealsStackView.distribution = .fillEqually
        mealsStackView.alignment = .fill
        mealsStackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.addArrangedSubview(mealsStackView)
        
        let buttonsStackView = DrawableStackView(frame: .zero)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fill
        buttonsStackView.alignment = .fill
        buttonsStackView.isLayoutMarginsRelativeArrangement = true
        buttonsStackView.backgroundColor = .purple
        
        stackView.addArrangedSubview(buttonsStackView)
        
        buttonsStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        let addButton = UIButton(frame: .zero)
        addButton.backgroundColor = .green
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 25)
        addButton.addTarget(self, action: #selector(self.addButtonClicked(sender:)), for: .touchUpInside)
        addButton.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        
        buttonsStackView.addArrangedSubview(addButton)
        
        let startOverButton = UIButton(frame: .zero)
        startOverButton.backgroundColor = .yellow
        startOverButton.setTitle("Start Over", for: .normal)
        startOverButton.setTitleColor(.black, for: .normal)
        startOverButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 25)
        startOverButton.addTarget(self, action: #selector(self.startOverButtonClicked(sender:)), for: .touchUpInside)
        startOverButton.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        
        buttonsStackView.addArrangedSubview(startOverButton)
    }
    
    private func initViewModel() {
        viewModel = MealsViewModel(networkProvider: NetworkProvider())
        
        viewModel?.didAddNewMeal = { [weak self] _ in
            self?.viewModelDidAddNewMeal()
        }
        viewModel?.didClearAllMeals = { [weak self] _ in
            self?.viewModelDidClearAllMeals()
        }
        viewModel?.didShuffleDishes = { [weak self] (_, mealIndex: Int) in
            self?.viewModelDidShuffleMeal(mealIndex: mealIndex)
        }
    }
    
    private func updateMealStackView(at index: Int) {
        guard let meal = viewModel?.meals[index] else {
            return
        }
        
        let mealStackView = DrawableStackView(frame: .zero)
        
        mealStackView.translatesAutoresizingMaskIntoConstraints = false
        mealStackView.axis = .vertical
        mealStackView.distribution = .fill
        mealStackView.alignment = .fill
        mealStackView.isLayoutMarginsRelativeArrangement = true
        mealStackView.backgroundColor = .blue
        
        let titleStackView = UIStackView(frame: .zero)
        
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fill
        titleStackView.alignment = .fill
        titleStackView.isLayoutMarginsRelativeArrangement = true
        titleStackView.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = "Meal plan \(meal.mealIndex + 1)"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 30)
        titleLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        
        titleStackView.addArrangedSubview(titleLabel)
        
        let shuffleMealButton = UIButton(frame: .zero)
        shuffleMealButton.addTarget(self, action: #selector(self.shuffleMealButtonClicked(sender:)), for: .touchUpInside)
        shuffleMealButton.setImage(UIImage(named: "shuffle.png"), for: .normal)
        shuffleMealButton.imageEdgeInsets = UIEdgeInsetsMake(2.5, 10, 2.5, 10)
        shuffleMealButton.backgroundColor = .yellow
        shuffleMealButton.tag = index
        shuffleMealButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        shuffleMealButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        shuffleMealButton.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        
        titleStackView.addArrangedSubview(shuffleMealButton)
        
        mealStackView.addArrangedSubview(titleStackView)
        
        let dishesStackView = UIStackView(frame: .zero)
        dishesStackView.translatesAutoresizingMaskIntoConstraints = false
        dishesStackView.axis = .vertical
        dishesStackView.distribution = .fillEqually
        dishesStackView.alignment = .fill
        dishesStackView.isLayoutMarginsRelativeArrangement = true
        dishesStackView.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .vertical)
        
        mealStackView.addArrangedSubview(dishesStackView)
        
        for dish in meal.sortedDishes {
            let dishStackView = UIStackView(frame: .zero)
            dishStackView.translatesAutoresizingMaskIntoConstraints = false
            dishStackView.axis = .vertical
            dishStackView.distribution = .fill
            dishStackView.alignment = .center
            dishStackView.isLayoutMarginsRelativeArrangement = true
            dishStackView.spacing = 10
            
            let topSpacer = UIView(frame: .zero)
            topSpacer.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .vertical)
            dishStackView.addArrangedSubview(topSpacer)
            
            let dishLabel = UILabel(frame: .zero)
            dishLabel.text = "\(dish.title)\n\(dish.category.map { $0.rawValue.characters.first! })"
            dishLabel.numberOfLines = 0
            dishLabel.textColor = .white
            dishLabel.textAlignment = .center
            dishLabel.font = UIFont(name: "HelveticaNeue", size: 25)
            
            dishStackView.addArrangedSubview(dishLabel)
            
            let dishButtonsStackView = UIStackView(frame: .zero)
            dishButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
            dishButtonsStackView.axis = .horizontal
            dishButtonsStackView.distribution = .equalSpacing
            dishButtonsStackView.alignment = .center
            dishButtonsStackView.isLayoutMarginsRelativeArrangement = true
            dishButtonsStackView.spacing = 15
            
            let shuffleButton = DishUIButton(dish: dish, mealIndex: meal.mealIndex)
            shuffleButton.addTarget(self, action: #selector(self.shuffleDishButtonClicked(sender:)), for: .touchUpInside)
            shuffleButton.setImage(UIImage(named: "shuffle.png"), for: .normal)
            shuffleButton.imageEdgeInsets = UIEdgeInsetsMake(2.5, 10, 2.5, 10)
            shuffleButton.backgroundColor = .yellow
            shuffleButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
            shuffleButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            
            dishButtonsStackView.addArrangedSubview(shuffleButton)
            
            let infoButton = DishUIButton(dish: dish, mealIndex: meal.mealIndex)
            infoButton.addTarget(self, action: #selector(self.infoButtonClicked(sender:)), for: .touchUpInside)
            infoButton.setImage(UIImage(named: "info.png"), for: .normal)
            infoButton.imageEdgeInsets = UIEdgeInsetsMake(5, 12.5, 5, 12.5)
            infoButton.backgroundColor = .yellow
            infoButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
            infoButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            
            dishButtonsStackView.addArrangedSubview(infoButton)
            
            dishStackView.addArrangedSubview(dishButtonsStackView)
            
            let bottomSpacer = UIView(frame: .zero)
            bottomSpacer.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .vertical)
            dishStackView.addArrangedSubview(bottomSpacer)
            
            topSpacer.heightAnchor.constraint(equalTo: bottomSpacer.heightAnchor).isActive = true
            
            dishesStackView.addArrangedSubview(dishStackView)
        }
        
        var animateView = false
        if mealsStackView.arrangedSubviews.count <= index {
            mealsStackView.addArrangedSubview(mealStackView)
            if let mealCount = viewModel?.mealCount, mealCount > 1 {
                animateView = true
            }
        } else {
            let originalSubview = mealsStackView.arrangedSubviews[index]
            mealsStackView.removeArrangedSubview(originalSubview)
            originalSubview.removeFromSuperview()
            
            mealsStackView.insertArrangedSubview(mealStackView, at: index)
        }
        
        if animateView {
            mealStackView.isHidden = true
            UIView.animate(withDuration: 0.5) {
                mealStackView.isHidden = false
            }
        }
    }
    
    private func viewModelDidAddNewMeal() {
        if let count = viewModel?.mealCount {
            updateMealStackView(at: count - 1)
        }
    }
    
    private func viewModelDidClearAllMeals() {
        for subview in mealsStackView.arrangedSubviews {
            mealsStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        viewModel?.addNewMeal()
    }
    
    private func viewModelDidShuffleMeal(mealIndex: Int) {
        updateMealStackView(at: mealIndex)
    }
    
    func addButtonClicked(sender: Any?) {
        if let mealCount = viewModel?.mealCount, mealCount < 3 {
            viewModel?.addNewMeal()
        }
    }
    
    func startOverButtonClicked(sender: Any?) {
        viewModel?.clearAllMeals()
    }
    
    func shuffleDishButtonClicked(sender: DishUIButton) {
        viewModel?.shuffleDishes(mealIndex: sender.mealIndex, categories: sender.dish.category)
    }
    
    func shuffleMealButtonClicked(sender: UIButton) {
        viewModel?.shuffleDishes(mealIndex: sender.tag, categories: Category.allValues)
    }
    
    func infoButtonClicked(sender: DishUIButton) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ShowDishSegue", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "ShowDishSegue":
            guard let dishViewController = segue.destination as? DishViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let dishUIButton = sender as? DishUIButton else {
                fatalError("Unexpected sender: \(sender.debugDescription)")
            }
            dishViewController.dish = dishUIButton.dish
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "unknown")")
        }
    }
}
