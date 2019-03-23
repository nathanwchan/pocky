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
    private var dishStackViews = [UIStackView]()
    var mealPlan: MealPlan?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initViewModel()
        
        view.backgroundColor = UIColor(colorLiteralRed: (230/255), green: (230/255), blue: (230/255), alpha: 1)
        
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
        mealsStackView.layoutMargins = view.traitCollection.isIphone ? .init(top: 12, left: 12, bottom: 12, right: 12) : .init(top: 20, left: 20, bottom: 20, right: 20)
        mealsStackView.spacing = view.traitCollection.isIphone ? 12 : 20
        
        stackView.addArrangedSubview(mealsStackView)
        
        let buttonsStackView = UIStackView()
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fill
        buttonsStackView.alignment = .fill
        buttonsStackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.addArrangedSubview(buttonsStackView)
        
        buttonsStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        let addButton = UIButton(frame: .zero)
        addButton.backgroundColor = .white
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: view.traitCollection.isIphone ? 18 : 25)
        addButton.addTarget(self, action: #selector(self.addButtonClicked(sender:)), for: .touchUpInside)
        addButton.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        
        buttonsStackView.addArrangedSubview(addButton)
        
        addButton.titleLabel?.centerXAnchor.constraint(equalTo: buttonsStackView.centerXAnchor).isActive = true

        let saveButton = UIButton(frame: .zero)
        saveButton.backgroundColor = .white
        let imageEdgeInset: CGFloat = view.traitCollection.isIphone ? 6 : 8
        saveButton.imageEdgeInsets = .init(top: imageEdgeInset, left: imageEdgeInset, bottom: imageEdgeInset, right: imageEdgeInset)
        saveButton.setImage(UIImage(named: "addToFavorite.png"), for: .normal)
        saveButton.addTarget(self, action: #selector(self.saveButtonClicked(sender:)), for: .touchUpInside)
        saveButton.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        saveButton.heightAnchor.constraint(equalToConstant: view.traitCollection.isIphone ? 40 : 50).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: view.traitCollection.isIphone ? 40 : 50).isActive = true
        
        buttonsStackView.addArrangedSubview(saveButton)
        
        // Navigation button setup
        
        let startOverButton = UIBarButtonItem(title: "Start Over", style: .plain, target: self, action: #selector(self.startOverButtonClicked(sender:)))
        let negativeSpacerRight = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacerRight.width = -6;
        navigationItem.rightBarButtonItems = [negativeSpacerRight, startOverButton]
    }
    
    private func initViewModel() {
        viewModel = MealsViewModel()
        
        viewModel?.didInitViewModel = { [weak self] in
            self?.viewModelDidInit()
        }
        viewModel?.didAddNewMeal = { [weak self] in
            self?.viewModelDidAddNewMeal()
        }
        viewModel?.didClearAllMeals = { [weak self] in
            self?.viewModelDidClearAllMeals()
        }
        viewModel?.didShuffleDishes = { [weak self] mealIndex in
            self?.viewModelDidShuffleMeal(mealIndex: mealIndex)
        }
        viewModel?.didLoadMealPlan = { [weak self] in
            self?.viewModelDidLoadMealPlan()
        }
    }
    
    private func setupDishStackView(_ dishStackView: UIStackView) {
        dishStackView.translatesAutoresizingMaskIntoConstraints = false
        dishStackView.isLayoutMarginsRelativeArrangement = true
        if UIDevice.current.orientation.isPortrait {
            dishStackView.axis = .vertical
            dishStackView.distribution = .fill
            dishStackView.alignment = .center
            dishStackView.spacing = view.traitCollection.isIphone ? 3 : 5
        } else if UIDevice.current.orientation.isLandscape {
            dishStackView.axis = .horizontal
            dishStackView.distribution = .fill
            dishStackView.alignment = .center
            dishStackView.spacing = 10
        }
    }
    
    private func updateMealStackView(at index: Int, forceNoAnimate: Bool = false) {
        guard let meal = viewModel?.meals[index] else {
            return
        }
        
        let mealStackView = DrawableStackView()
        
        mealStackView.translatesAutoresizingMaskIntoConstraints = false
        mealStackView.axis = .vertical
        mealStackView.distribution = .fill
        mealStackView.alignment = .fill
        mealStackView.isLayoutMarginsRelativeArrangement = true
        mealStackView.backgroundColor = .white
        mealStackView.cornerRadius = view.traitCollection.isIphone ? 6 : 10
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = "Meal \(meal.mealIndex + 1)"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "HelveticaNeue", size: view.traitCollection.isIphone ? 15 : 20)
        titleLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        titleLabel.layoutMargins = .init(top: 0, left: view.traitCollection.isIphone ? 5 : 7, bottom: 0, right: 0)

        mealStackView.addArrangedSubview(titleLabel)
        
        let dishesStackView = UIStackView(frame: .zero)
        dishesStackView.translatesAutoresizingMaskIntoConstraints = false
        dishesStackView.axis = .vertical
        dishesStackView.distribution = .fillEqually
        dishesStackView.alignment = .center
        dishesStackView.isLayoutMarginsRelativeArrangement = true
        dishesStackView.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .vertical)
        
        mealStackView.addArrangedSubview(dishesStackView)
        
        for dish in meal.sortedDishes {
            let dishStackView = UIStackView(frame: .zero)
            setupDishStackView(dishStackView)
            dishStackViews.append(dishStackView)
            
            let topSpacer = UIView(frame: .zero)
            topSpacer.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .vertical)
            dishStackView.addArrangedSubview(topSpacer)
            
            let dishLabel = UILabel(frame: .zero)
            dishLabel.text = dish.title
            dishLabel.numberOfLines = 1
            dishLabel.textColor = .black
            dishLabel.textAlignment = .center
            dishLabel.font = UIFont(name: "HelveticaNeue", size: view.traitCollection.isIphone ? 16 : 22)
            dishLabel.adjustsFontSizeToFitWidth = true
            dishLabel.sizeToFit()
            
            dishStackView.addArrangedSubview(dishLabel)
            
            let dishButtonsStackView = UIStackView(frame: .zero)
            dishButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
            dishButtonsStackView.axis = .horizontal
            dishButtonsStackView.distribution = .equalSpacing
            dishButtonsStackView.alignment = .center
            dishButtonsStackView.isLayoutMarginsRelativeArrangement = true
            dishButtonsStackView.spacing = view.traitCollection.isIphone ? 8 : 12
            
            let shuffleButton = DishUIButton(dish: dish, mealIndex: meal.mealIndex)
            shuffleButton.addTarget(self, action: #selector(self.shuffleDishButtonClicked(sender:)), for: .touchUpInside)
            shuffleButton.setImage(UIImage(named: "shuffle.png"), for: .normal)
            shuffleButton.imageEdgeInsets = view.traitCollection.isIphone ? UIEdgeInsetsMake(1.5, 6, 1.5, 6) : UIEdgeInsetsMake(2.5, 10, 2.5, 10)
            shuffleButton.backgroundColor = .lightGray
            shuffleButton.layer.cornerRadius = 4
            shuffleButton.heightAnchor.constraint(equalToConstant: view.traitCollection.isIphone ? 28 : 42).isActive = true
            shuffleButton.widthAnchor.constraint(equalToConstant: view.traitCollection.isIphone ? 40 : 60).isActive = true
            
            dishButtonsStackView.addArrangedSubview(shuffleButton)
            
            let infoButton = DishUIButton(dish: dish, mealIndex: meal.mealIndex)
            infoButton.addTarget(self, action: #selector(self.infoButtonClicked(sender:)), for: .touchUpInside)
            infoButton.setImage(UIImage(named: "info.png"), for: .normal)
            infoButton.imageEdgeInsets = view.traitCollection.isIphone ? UIEdgeInsetsMake(3, 7.5, 3, 7.5) : UIEdgeInsetsMake(5, 12.5, 5, 12.5)
            infoButton.backgroundColor = .lightGray
            infoButton.layer.cornerRadius = 4
            infoButton.heightAnchor.constraint(equalToConstant: view.traitCollection.isIphone ? 28 : 42).isActive = true
            infoButton.widthAnchor.constraint(equalToConstant: view.traitCollection.isIphone ? 40 : 60).isActive = true
            
            dishButtonsStackView.addArrangedSubview(infoButton)
            
            dishStackView.addArrangedSubview(dishButtonsStackView)
            
            let bottomSpacer = UIView(frame: .zero)
            bottomSpacer.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .vertical)
            dishStackView.addArrangedSubview(bottomSpacer)
            
            topSpacer.heightAnchor.constraint(equalTo: bottomSpacer.heightAnchor).isActive = true
            
            dishesStackView.addArrangedSubview(dishStackView)
        }

        let shuffleMealStackView = UIStackView(frame: .zero)

        shuffleMealStackView.translatesAutoresizingMaskIntoConstraints = false
        shuffleMealStackView.axis = .horizontal
        shuffleMealStackView.distribution = .fill
        shuffleMealStackView.alignment = .fill
        shuffleMealStackView.isLayoutMarginsRelativeArrangement = true
        shuffleMealStackView.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)

        let shuffleMealButton = UIButton(frame: .zero)
        shuffleMealButton.addTarget(self, action: #selector(self.shuffleMealButtonClicked(sender:)), for: .touchUpInside)
        shuffleMealButton.setImage(UIImage(named: "shuffle.png"), for: .normal)
        shuffleMealButton.imageEdgeInsets = view.traitCollection.isIphone ? UIEdgeInsetsMake(1.5, 6, 1.5, 6) : UIEdgeInsetsMake(2.5, 10, 2.5, 10)
        shuffleMealButton.backgroundColor = .lightGray
        shuffleMealButton.layer.cornerRadius = 4
        shuffleMealButton.tag = index
        shuffleMealButton.heightAnchor.constraint(equalToConstant: view.traitCollection.isIphone ? 28 : 42).isActive = true
        shuffleMealButton.widthAnchor.constraint(equalToConstant: view.traitCollection.isIphone ? 40 : 60).isActive = true
        shuffleMealButton.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)

        shuffleMealStackView.addArrangedSubview(shuffleMealButton)

        let spacerView = UIView()
        shuffleMealStackView.addArrangedSubview(spacerView)

        mealStackView.addArrangedSubview(shuffleMealStackView)
        
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
        
        if animateView && !forceNoAnimate {
            mealStackView.isHidden = true
            UIView.animate(withDuration: 0.5) {
                mealStackView.isHidden = false
            }
        }
    }
    
    private func viewModelDidInit() {
        if let mealPlan = mealPlan {
            viewModel?.loadMealPlan(mealPlan)
        } else if let count = viewModel?.mealCount, count == 0 {
            viewModel?.addNewMeal()
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
    
    private func viewModelDidLoadMealPlan() {
        if let count = viewModel?.mealCount {
            for i in 0..<count {
                updateMealStackView(at: i, forceNoAnimate: true)
            }
        }
    }
    
    func addButtonClicked(sender: Any?) {
        if let mealCount = viewModel?.mealCount, mealCount < 3 {
            viewModel?.addNewMeal()
        }
    }
    
    func startOverButtonClicked(sender: Any?) {
        viewModel?.clearAllMeals()
        dishStackViews = []
    }
    
    func shuffleDishButtonClicked(sender: DishUIButton) {
        viewModel?.shuffleDishes(mealIndex: sender.mealIndex, categories: sender.dish.category)
    }
    
    func shuffleMealButtonClicked(sender: UIButton) {
        viewModel?.shuffleDishes(mealIndex: sender.tag, categories: Category.allValuesUsedForPlanning)
    }
    
    func saveButtonClicked(sender: UIButton) {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        let title = formatter.string(from: currentDateTime) // Example format: October 8, 2016 at 10:48:53 PM
        
        viewModel?.saveMealPlan(title: title)
        
        let alertController = UIAlertController(title: "Saved meal plan to your favorites", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Sweet!", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func infoButtonClicked(sender: DishUIButton) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ShowDishSegue", sender: sender)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        for dishStackView in dishStackViews {
            setupDishStackView(dishStackView)
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
            dishViewController.dishId = dishUIButton.dish.id
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "unknown")")
        }
    }
}
