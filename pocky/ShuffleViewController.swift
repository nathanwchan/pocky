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
    private let titleLabel = UILabel(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        
        view.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        
        for i in 0..<mealCount {
            let mealStackView = DrawableStackView(frame: .zero)
            
            mealStackView.translatesAutoresizingMaskIntoConstraints = false
            mealStackView.axis = .vertical
            mealStackView.distribution = .fillEqually
            mealStackView.alignment = .fill
            mealStackView.isLayoutMarginsRelativeArrangement = true
            mealStackView.backgroundColor = .blue
            mealStackView.borderColor = UIColor.white.cgColor
            mealStackView.borderWidth = 5
            
            let titleLabel = UILabel(frame: .zero)
            titleLabel.text = "Meal \(i + 1)"
            titleLabel.textColor = .white
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont(name: "HelveticaNeue", size: 40)
            titleLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
            
            let dishesStackView = UIStackView(frame: .zero)
            dishesStackView.translatesAutoresizingMaskIntoConstraints = false
            dishesStackView.axis = .vertical
            dishesStackView.distribution = .fill
            dishesStackView.alignment = .fill
            dishesStackView.isLayoutMarginsRelativeArrangement = true
            
            let dishNames = ["Chicken pasta", "Honey garlic salmon", "Garlic a-cai", "Roasted asparagus", "White rice", "Roasted sweet potatoes"]
            for _ in 0..<arc4random_uniform(3)+1 {
                let dishLabel = UILabel(frame: .zero)
                dishLabel.text = dishNames[Int(arc4random_uniform(UInt32(dishNames.count)))]
                dishLabel.textColor = .white
                dishLabel.textAlignment = .left
                dishLabel.font = UIFont(name: "HelveticaNeue", size: 25)
                dishLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .vertical)
                
                dishesStackView.addArrangedSubview(dishLabel)
            }
            
            mealStackView.addArrangedSubview(titleLabel)
            mealStackView.addArrangedSubview(dishesStackView)
            
            stackView.addArrangedSubview(mealStackView)
        }
        

    }
}
