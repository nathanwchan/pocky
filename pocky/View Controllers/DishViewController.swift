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
    case creating
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
    private let linkStackView = UIStackView(frame: .zero)
    private let linkTextField = UITextField(frame: .zero)
    private let notesStackView = UIStackView(frame: .zero)
    private let notesTextView = UITextView(frame: .zero)
    private let saveButton = UIButton(frame: .zero)
    private let deleteButton = UIButton(frame: .zero)
    private let createButton = UIButton(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewModel()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        view.backgroundColor = UIColor(red: 230, green: 230, blue: 230, alpha: 1)
        
        let spacing: CGFloat = view.traitCollection.isIphone ? 12 : 20

        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag
        scrollView.alwaysBounceVertical = true
        
        view.addSubview(scrollView)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = spacing
        stackView.backgroundColor = .white
        stackView.cornerRadius = view.traitCollection.isIphone ? 6 : 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        scrollView.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spacing).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: spacing).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -spacing).isActive = true
        
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "HelveticaNeue", size: view.traitCollection.isIphone ? 22 : 30)
        titleLabel.numberOfLines = 0
        
        categoryLabel.textColor = .black
        categoryLabel.textAlignment = .left
        categoryLabel.font = UIFont(name: "HelveticaNeue-Bold", size: view.traitCollection.isIphone ? 12 : 15)
        
        linkLabel.textColor = .blue
        linkLabel.textAlignment = .left
        linkLabel.font = UIFont(name: "HelveticaNeue", size: view.traitCollection.isIphone ? 15 : 20)
        linkLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapLink)))
        linkLabel.isUserInteractionEnabled = true
        
        notesLabel.textColor = .black
        notesLabel.textAlignment = .left
        notesLabel.font = UIFont(name: "HelveticaNeue", size: view.traitCollection.isIphone ? 15 : 20)
        notesLabel.numberOfLines = 0
        
        titleTextField.textColor = .black
        titleTextField.textAlignment = .left
        titleTextField.font = UIFont(name: "HelveticaNeue", size: view.traitCollection.isIphone ? 22 : 30)
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
            categoryLabel.font = UIFont(name: "HelveticaNeue-Bold", size: view.traitCollection.isIphone ? 12 : 15)
            
            categoryStackView.addArrangedSubview(categoryLabel)
            categoriesStackView.addArrangedSubview(categoryStackView)
        }
        
        linkStackView.translatesAutoresizingMaskIntoConstraints = false
        linkStackView.axis = .horizontal
        linkStackView.distribution = .fill
        linkStackView.alignment = .firstBaseline
        linkStackView.spacing = 5
        
        let linkStaticLabel = UILabel(frame: .zero)
        linkStaticLabel.text = "LINK"
        linkStaticLabel.textColor = .black
        linkStaticLabel.textAlignment = .left
        linkStaticLabel.font = UIFont(name: "HelveticaNeue-Bold", size: view.traitCollection.isIphone ? 12 : 15)
        linkStaticLabel.widthAnchor.constraint(equalToConstant: view.traitCollection.isIphone ? 50 : 60).isActive = true
        
        linkStackView.addArrangedSubview(linkStaticLabel)
        
        linkTextField.textColor = .black
        linkTextField.textAlignment = .left
        linkTextField.font = UIFont(name: "HelveticaNeue", size: view.traitCollection.isIphone ? 15 : 20)
        linkTextField.borderStyle = .line
        linkTextField.autocapitalizationType = .none
        linkTextField.clearButtonMode = .always
        linkTextField.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        
        linkStackView.addArrangedSubview(linkTextField)
        
        notesStackView.translatesAutoresizingMaskIntoConstraints = false
        notesStackView.axis = .horizontal
        notesStackView.distribution = .fill
        notesStackView.alignment = .top
        notesStackView.spacing = 5
        
        let notesStaticLabel = UILabel(frame: .zero)
        notesStaticLabel.text = "NOTES"
        notesStaticLabel.textColor = .black
        notesStaticLabel.textAlignment = .left
        notesStaticLabel.font = UIFont(name: "HelveticaNeue-Bold", size: view.traitCollection.isIphone ? 12 : 15)
        notesStaticLabel.widthAnchor.constraint(equalToConstant: view.traitCollection.isIphone ? 50 : 60).isActive = true
        
        notesStackView.addArrangedSubview(notesStaticLabel)
        
        notesTextView.textColor = .black
        notesTextView.textAlignment = .left
        notesTextView.font = UIFont(name: "HelveticaNeue", size: view.traitCollection.isIphone ? 15 : 20)
        notesTextView.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        notesTextView.translatesAutoresizingMaskIntoConstraints = true
        notesTextView.sizeToFit()
        notesTextView.isScrollEnabled = false
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.borderColor = UIColor.black.cgColor
        notesTextView.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        
        notesStackView.addArrangedSubview(notesTextView)
        
        saveButton.addTarget(self, action: #selector(self.saveOrCreateButtonClicked(sender:)), for: .touchUpInside)
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .blue
        saveButton.contentEdgeInsets = view.traitCollection.isIphone ? UIEdgeInsets.init(top: 6, left: 12, bottom: 6, right: 12) : UIEdgeInsets.init(top: 10, left: 20, bottom: 10, right: 20)
        saveButton.layer.cornerRadius = 4

        deleteButton.addTarget(self, action: #selector(self.deleteButtonClicked(sender:)), for: .touchUpInside)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.backgroundColor = .red
        deleteButton.contentEdgeInsets = view.traitCollection.isIphone ? UIEdgeInsets.init(top: 6, left: 12, bottom: 6, right: 12) : UIEdgeInsets.init(top: 10, left: 20, bottom: 10, right: 20)
        deleteButton.layer.cornerRadius = 4
        
        createButton.addTarget(self, action: #selector(self.saveOrCreateButtonClicked(sender:)), for: .touchUpInside)
        createButton.setTitle("Create", for: .normal)
        createButton.backgroundColor = .blue
        createButton.contentEdgeInsets = view.traitCollection.isIphone ? UIEdgeInsets.init(top: 6, left: 12, bottom: 6, right: 12) : UIEdgeInsets.init(top: 10, left: 20, bottom: 10, right: 20)
        createButton.layer.cornerRadius = 4
        
        if let dishId = dishId {
            viewModel?.getDish(id: dishId)
        } else {
            viewState = .creating
        }
    }
    
    private func initViewModel() {
        viewModel = DishViewModel()
        
        viewModel?.didGetDish = { [weak self] in
            self?.updateView()
        }
        viewModel?.didCreateDish = { [weak self] dishId in
            self?.dishId = dishId
            self?.viewModel?.getDish(id: dishId)
        }
    }
    
    func updateView() {
        let negativeSpacerRight = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacerRight.width = -6;
        
        for subview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        switch viewState {
        case .creating:
            navigationItem.title = "Create a new dish"
            
            titleTextField.becomeFirstResponder()
            stackView.addArrangedSubview(titleTextField)
            titleTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: stackView.layoutMargins.left).isActive = true
            titleTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -stackView.layoutMargins.right).isActive = true
            
            stackView.addArrangedSubview(categoriesStackView)
            
            stackView.addArrangedSubview(linkStackView)
            linkStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: stackView.layoutMargins.left).isActive = true
            linkStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -stackView.layoutMargins.right).isActive = true
            
            stackView.addArrangedSubview(notesStackView)
            notesStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: stackView.layoutMargins.left).isActive = true
            notesStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -stackView.layoutMargins.right).isActive = true
            
            stackView.addArrangedSubview(createButton)
        case .viewing:
            guard let dish = viewModel?.dish else {
                return
            }
            
            let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.editButtonClicked(sender:)))
        
            navigationItem.title = dish.title
            navigationItem.rightBarButtonItems = [negativeSpacerRight, editButton]
            
            titleLabel.text = dish.title
            stackView.addArrangedSubview(titleLabel)
            
            categoryLabel.text = "\(dish.category.map({ String(describing: $0).uppercased() }).joined(separator: ", "))"
            stackView.addArrangedSubview(categoryLabel)
            
            if let link = dish.link {
                let underlineAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle): NSUnderlineStyle.single.rawValue]
                let underlineAttributedString = NSAttributedString(string: link, attributes: convertToOptionalNSAttributedStringKeyDictionary(underlineAttribute))
                linkLabel.attributedText = underlineAttributedString
                stackView.addArrangedSubview(linkLabel)
            }
            
            if let notes = dish.notes {
                notesLabel.text = notes
                stackView.addArrangedSubview(notesLabel)
            }
        case .editing:
            guard let dish = viewModel?.dish else {
                return
            }
            
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelButtonClicked(sender:)))
            
            navigationItem.title = dish.title
            navigationItem.rightBarButtonItems = [negativeSpacerRight, cancelButton]
            
            titleTextField.text = dish.title
            stackView.addArrangedSubview(titleTextField)
            titleTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: stackView.layoutMargins.left).isActive = true
            titleTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -stackView.layoutMargins.right).isActive = true
            
            for categorySwitch in categorySwitches {
                categorySwitch.setOn(dish.category.map({ Category.index(of: $0) }).contains(categorySwitch.tag), animated: false)
            }
            stackView.addArrangedSubview(categoriesStackView)
            
            linkTextField.text = dish.link ?? ""
            stackView.addArrangedSubview(linkStackView)
            linkStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: stackView.layoutMargins.left).isActive = true
            linkStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -stackView.layoutMargins.right).isActive = true
            
            notesTextView.text = dish.notes ?? ""
            stackView.addArrangedSubview(notesStackView)
            notesStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: stackView.layoutMargins.left).isActive = true
            notesStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -stackView.layoutMargins.right).isActive = true


            let buttonsStackView = UIStackView(frame: .zero)
            buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
            buttonsStackView.axis = .horizontal
            buttonsStackView.distribution = .fill
            buttonsStackView.alignment = .center
            buttonsStackView.spacing = 10

            buttonsStackView.addArrangedSubview(saveButton)
            buttonsStackView.addArrangedSubview(deleteButton)

            stackView.addArrangedSubview(buttonsStackView)
        }
    }
    
    func openUrlInModal(_ url: URL?) {
        if let url = url {
            if UIApplication.shared.canOpenURL(url) {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Error", message: "URL is invalid. Maybe it's missing http:// ?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func tapLink() {
        if let link = viewModel?.dish?.link {
            let url = URL(string: link)
            openUrlInModal(url)
        }
    }
    
    @objc func editButtonClicked(sender: UIButton) {
        viewState = .editing
    }

    @objc func cancelButtonClicked(sender: UIButton) {
        viewState = .viewing
    }
    
    @objc func saveOrCreateButtonClicked(sender: UIButton) {
        guard let title = titleTextField.text.nilIfEmpty else {
            let alertController = UIAlertController(title: "Error", message: "You must set a title!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let categories = categorySwitches.compactMap { categorySwitch in
            categorySwitch.isOn ? Category.allValues[categorySwitch.tag] : nil
        }
        if categories.isEmpty {
            let alertController = UIAlertController(title: "Error", message: "You must set at least one category!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let dish = Dish(id: viewModel?.dish?.id,
                        title: title,
                        category: categories,
                        link: linkTextField.text,
                        notes: notesTextView.text)
        if dish.id == nil {
            viewModel?.createDish(dish: dish)
        } else {
            viewModel?.updateDish(dish: dish)
        }
        viewState = .viewing
    }

    @objc func deleteButtonClicked(sender: UIButton) {
        let alertController = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            if let dishId = self.dishId {
                self.viewModel?.deleteDish(id: dishId)
                self.navigationController?.popViewController(animated: true)
            }
        }
        alertController.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
