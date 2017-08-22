//
//  ShuffleViewController.swift
//  pocky
//
//  Created by Nathan Chan on 8/21/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

class ShuffleViewController: UIViewController {

    private var viewModel = MealsViewModel()
    private let stackView = UIStackView(frame: .zero)
    private let mealsStackView = UIStackView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindToViewModel()
        
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
        
        viewModel.addNewMeal()
    }
    
    private func bindToViewModel() {
        self.viewModel.didAddNewMeal = { [weak self] _ in
            self?.viewModelDidAddNewMeal()
        }
        self.viewModel.didClearAllMeals = { [weak self] _ in
            self?.viewModelDidClearAllMeals()
        }
    }
    
    private func viewModelDidAddNewMeal() {
    
        guard let mealViewModel = viewModel.mealViewModels.last else {
            return
        }
        
        let mealStackView = DrawableStackView(frame: .zero)
        
        mealStackView.translatesAutoresizingMaskIntoConstraints = false
        mealStackView.axis = .vertical
        mealStackView.distribution = .fill
        mealStackView.alignment = .fill
        mealStackView.isLayoutMarginsRelativeArrangement = true
        mealStackView.backgroundColor = .blue
//        mealStackView.borderColor = UIColor.white.cgColor
//        mealStackView.borderWidth = 5
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = "Meal plan \(mealViewModel.mealNumber)"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 30)
        titleLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        
        mealStackView.addArrangedSubview(titleLabel)
        
        let dishesStackView = UIStackView(frame: .zero)
        dishesStackView.translatesAutoresizingMaskIntoConstraints = false
        dishesStackView.axis = .vertical
        dishesStackView.distribution = .fillEqually
        dishesStackView.alignment = .fill
        dishesStackView.isLayoutMarginsRelativeArrangement = true
        dishesStackView.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .vertical)
        
        mealStackView.addArrangedSubview(dishesStackView)
        
        for dish in mealViewModel.dishes {
            let dishLabel = UILabel(frame: .zero)
            dishLabel.text = dish.title
            dishLabel.textColor = .white
            dishLabel.textAlignment = .center
            dishLabel.font = UIFont(name: "HelveticaNeue", size: 25)
            
            dishesStackView.addArrangedSubview(dishLabel)
        }
        
        mealsStackView.addArrangedSubview(mealStackView)
        
        if viewModel.mealCount > 1 {
            mealStackView.isHidden = true
            
            UIView.animate(withDuration: 0.5) {
                mealStackView.isHidden = false
            }
        }
    }
    
    private func viewModelDidClearAllMeals() {
        for subview in mealsStackView.arrangedSubviews {
            mealsStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        viewModel.addNewMeal()
    }
    
    func addButtonClicked(sender: Any?) {
        if viewModel.mealCount < 3 {
            viewModel.addNewMeal()
        }
    }
    
    func startOverButtonClicked(sender: Any?) {
        viewModel.clearAllMeals()
    }
}
