//
//  ShuffleViewController.swift
//  pocky
//
//  Created by Nathan Chan on 8/21/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

class ShuffleViewController: UIViewController {

    var mealCount: Int = 1
    private let stackView = UIStackView(frame: .zero)
    private let mealsStackView = UIStackView(frame: .zero)
    private let scrollView = UIScrollView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        addNewMeal()
        
        let addButton = UIButton(frame: .zero)
        addButton.backgroundColor = .green
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 25)
        addButton.addTarget(self, action: #selector(self.addButtonClicked(sender:)), for: .touchUpInside)
        addButton.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        
        stackView.addArrangedSubview(addButton)
        
        addButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
    }

    func addNewMeal() {
    
        let mealStackView = DrawableStackView(frame: .zero)
        
        mealStackView.translatesAutoresizingMaskIntoConstraints = false
        mealStackView.axis = .vertical
        mealStackView.distribution = .fill
        mealStackView.alignment = .fill
        mealStackView.isLayoutMarginsRelativeArrangement = true
        mealStackView.backgroundColor = .blue
        mealStackView.borderColor = UIColor.white.cgColor
//            mealStackView.borderWidth = 5
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = "Meal plan \(mealCount)"
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
        
        let dishNames = ["Chicken pasta", "Honey garlic salmon", "Garlic a-cai", "Roasted asparagus", "White rice", "Roasted sweet potatoes"]
        for _ in 0..<arc4random_uniform(3)+1 {
            let dishLabel = UILabel(frame: .zero)
            dishLabel.text = dishNames[Int(arc4random_uniform(UInt32(dishNames.count)))]
            dishLabel.textColor = .white
            dishLabel.textAlignment = .center
            dishLabel.font = UIFont(name: "HelveticaNeue", size: 25)
            
            dishesStackView.addArrangedSubview(dishLabel)
        }
        
        mealsStackView.addArrangedSubview(mealStackView)
        mealStackView.isHidden = true
        
        UIView.animate(withDuration: 0.5) {
            mealStackView.isHidden = false
        }
    }
    
    func addButtonClicked(sender: Any?) {
        if mealCount < 3 {
            mealCount += 1
            addNewMeal()
        }
//        if mealCount == 4 {
//            stackView.removeFromSuperview()
//            
//            scrollView.backgroundColor = .yellow
//            scrollView.translatesAutoresizingMaskIntoConstraints = false
//            
//            view.addSubview(scrollView)
//            
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//            scrollView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
//            scrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
//            
//            scrollView.addSubview(stackView)
//            
//            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
//            stackView.bottomAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//            stackView.topAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
//        }
    }
}
