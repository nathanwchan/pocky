//
//  DishViewController.swift
//  pocky
//
//  Created by Nathan Chan on 8/28/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit
import SafariServices

enum State {
    case viewing
    case editing
}

class DishViewController: UIViewController {

    var dishId: String?
    private var viewModel: DishViewModel?
    private var viewState: State = .viewing {
        didSet {
            updateView()
        }
    }
    private let stackView = DrawableStackView()
    private let titleLabel = UILabel(frame: .zero)
    private let categoryLabel = UILabel(frame: .zero)
    private let linkLabel = UILabel(frame: .zero)
    private let notesLabel = UILabel(frame: .zero)
    private let titleTextField = UITextField(frame: .zero)
    private let categoriesStackView = UIStackView(frame: .zero)
    private var categorySwitches: [UISwitch] = []
    private let linkTextField = UITextField(frame: .zero)
    private let notesTextView = UITextView(frame: .zero)
    private let saveButton = UIButton(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewModel()
        
        view.backgroundColor = UIColor(colorLiteralRed: (230/255), green: (230/255), blue: (230/255), alpha: 1)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.backgroundColor = .white
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 20)
        
        view.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        stackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20).isActive = true
        
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 30)
        titleLabel.numberOfLines = 0
        
        categoryLabel.textColor = .black
        categoryLabel.textAlignment = .left
        categoryLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        
        linkLabel.textColor = .blue
        linkLabel.textAlignment = .left
        linkLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        linkLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapLink)))
        linkLabel.isUserInteractionEnabled = true
        
        notesLabel.textColor = .black
        notesLabel.textAlignment = .left
        notesLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        notesLabel.numberOfLines = 0
        
        titleTextField.textColor = .black
        titleTextField.textAlignment = .left
        titleTextField.font = UIFont(name: "HelveticaNeue", size: 30)
        titleTextField.borderStyle = .line
        
        categoriesStackView.translatesAutoresizingMaskIntoConstraints = false
        categoriesStackView.axis = .vertical
        categoriesStackView.distribution = .fill
        categoriesStackView.alignment = .leading
        categoriesStackView.spacing = 5
        
        for category in Category.allValues {
            let categoryStackView = UIStackView(frame: .zero)
            categoryStackView.translatesAutoresizingMaskIntoConstraints = false
            categoryStackView.axis = .horizontal
            categoryStackView.distribution = .fill
            categoryStackView.alignment = .center
            categoryStackView.spacing = 10
            
            let categorySwitch = UISwitch(frame: .zero)
            categorySwitch.tag = Category.index(of: category)
            categorySwitches.append(categorySwitch)
            categoryStackView.addArrangedSubview(categorySwitch)
            
            let categoryLabel = UILabel(frame: .zero)
            categoryLabel.text = String(describing: category).uppercased()
            categoryLabel.textColor = .black
            categoryLabel.textAlignment = .left
            categoryLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
            
            categoryStackView.addArrangedSubview(categoryLabel)
            categoriesStackView.addArrangedSubview(categoryStackView)
        }
        
        linkTextField.textColor = .black
        linkTextField.textAlignment = .left
        linkTextField.font = UIFont(name: "HelveticaNeue", size: 20)
        linkTextField.borderStyle = .line
        linkTextField.clearButtonMode = .whileEditing
        
        notesTextView.textColor = .black
        notesTextView.textAlignment = .left
        notesTextView.font = UIFont(name: "HelveticaNeue", size: 20)
        notesTextView.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .vertical)
        notesTextView.translatesAutoresizingMaskIntoConstraints = true
        notesTextView.sizeToFit()
        notesTextView.isScrollEnabled = false
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.borderColor = UIColor.black.cgColor
        
        saveButton.addTarget(self, action: #selector(self.saveButtonClicked(sender:)), for: .touchUpInside)
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .blue
        saveButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
        saveButton.layer.cornerRadius = 4
        
        guard let dishId = dishId else {
            fatalError("No dishId provided")
        }
        viewModel?.getDish(id: dishId)
    }
    
    private func initViewModel() {
        viewModel = DishViewModel(networkProvider: NetworkProvider())
        
        viewModel?.didGetDish = { [weak self] _ in
            self?.updateView()
        }
    }
    
    func updateView() {
        guard let dish = viewModel?.dish else {
            return
        }
        
        navigationItem.title = dish.title
        
        let negativeSpacerRight = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacerRight.width = -6;
        
        for subview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        switch viewState {
        case .viewing:
            let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.editButtonClicked(sender:)))
        
            navigationItem.rightBarButtonItems = [negativeSpacerRight, editButton]
            
            titleLabel.text = dish.title
            stackView.addArrangedSubview(titleLabel)
            
            categoryLabel.text = "\(dish.category.map({ String(describing: $0).uppercased() }).joined(separator: ", "))"
            stackView.addArrangedSubview(categoryLabel)
            
            if let link = dish.link {
                let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
                let underlineAttributedString = NSAttributedString(string: link, attributes: underlineAttribute)
                linkLabel.attributedText = underlineAttributedString
                stackView.addArrangedSubview(linkLabel)
            }
            
            if let notes = dish.notes {
                notesLabel.text = notes
                stackView.addArrangedSubview(notesLabel)
            }
        case .editing:
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelButtonClicked(sender:)))
            
            navigationItem.rightBarButtonItems = [negativeSpacerRight, cancelButton]
            
            titleTextField.text = dish.title
            stackView.addArrangedSubview(titleTextField)
            
            for categorySwitch in categorySwitches {
                categorySwitch.setOn(dish.category.map({ Category.index(of: $0) }).contains(categorySwitch.tag), animated: false)
            }
            stackView.addArrangedSubview(categoriesStackView)
            
            linkTextField.text = dish.link ?? ""
            stackView.addArrangedSubview(linkTextField)
            
            notesTextView.text = dish.notes ?? ""
            stackView.addArrangedSubview(notesTextView)
            
            stackView.addArrangedSubview(saveButton)
        }
    }
    
    func openUrlInModal(_ url: URL?) {
        if let url = url {
            if UIApplication.shared.canOpenURL(url) {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func tapLink() {
        if let link = viewModel?.dish?.link {
            let url = URL(string: link)
            openUrlInModal(url)
        }
    }
    
    func editButtonClicked(sender: UIButton) {
        viewState = .editing
    }

    func cancelButtonClicked(sender: UIButton) {
        viewState = .viewing
    }
    
    func saveButtonClicked(sender: UIButton) {
        guard let dishID = viewModel?.dish?.id else {
            return
        }
        
        guard let title = titleTextField.text else {
            // alert title must be set
            return
        }
        
        let categories = categorySwitches.flatMap { categorySwitch in
            categorySwitch.isOn ? Category.allValues[categorySwitch.tag] : nil
        }
        if categories.isEmpty {
            // alert at least one category must be set
            return
        }
        
        let dish = Dish(id: dishID,
                        title: title,
                        category: categories,
                        link: linkTextField.text,
                        notes: notesTextView.text)
        viewModel?.saveDish(dish: dish)
        
        viewState = .viewing
    }
}
