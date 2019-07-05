//
//  SearchViewController.swift
//  pocky
//
//  Created by Nathan Chan on 8/31/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var filterViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterStackView: UIStackView!

    var filterViewWidth: CGFloat = 150
    var filterViewIsVisible = false
    var filterCategorySwitches: [UISwitch] = []

    fileprivate var dishesViewModel: DishesViewModel!
    fileprivate var dishesToShow: [Dish] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // remove separator lines between empty rows
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // dynamic cell height based on inner content
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 50
        
        self.searchBar.delegate = self

        dishesViewModel = DishesViewModel()
        dishesViewModel?.didGetAllDishes = { [weak self] in
            self?.showAllDishes()
        }
        
        self.searchBar.becomeFirstResponder()
        self.tableView.keyboardDismissMode = .onDrag

        let addNewDishButton = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(self.addNewDishButtonClicked(sender:)))
        navigationItem.leftBarButtonItem = addNewDishButton
        
        let filterDishesButton = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(self.filterDishesButtonClicked(sender:)))
        navigationItem.rightBarButtonItem = filterDishesButton

        for category in Category.allValues {
            let categoryStackView = UIStackView(frame: .zero)
            categoryStackView.translatesAutoresizingMaskIntoConstraints = false
            categoryStackView.axis = .horizontal
            categoryStackView.distribution = .fill
            categoryStackView.alignment = .center
            categoryStackView.spacing = 10

            let categorySwitch = UISwitch(frame: .zero)
            categorySwitch.tag = Category.index(of: category)
            categorySwitch.addTarget(self, action: #selector(filterSwitchChanged), for: .valueChanged)
            filterCategorySwitches.append(categorySwitch)
            categoryStackView.addArrangedSubview(categorySwitch)

            let categoryLabel = UILabel(frame: .zero)
            categoryLabel.text = String(describing: category).uppercased()
            categoryLabel.textColor = .black
            categoryLabel.textAlignment = .left
            categoryLabel.font = UIFont(name: "HelveticaNeue-Bold", size: view.traitCollection.isIphone ? 12 : 15)

            categoryStackView.addArrangedSubview(categoryLabel)
            filterStackView.addArrangedSubview(categoryStackView)
        }

        filterSwitchChanged()
    }
    
    func showAllDishes() {
        if let dishes = dishesViewModel.allDishes {
            dishesToShow = dishes
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        view.endEditing(true)
    }
    
    @objc func addNewDishButtonClicked(sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ShowAddNewDishSegue", sender: sender)
        }
    }

    @objc func filterDishesButtonClicked(sender: UIBarButtonItem) {
        toggleFilterView()
    }

    func toggleFilterView() {
        filterViewIsVisible.toggle()
        filterViewTrailingConstraint.constant = filterViewIsVisible ? 0 : filterViewWidth
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { _ in }
    }

    @objc func filterSwitchChanged() {
        searchBar.text = nil
        let filteredCategories = Set(filterCategorySwitches.filter({ $0.isOn }).map({ Category.allValues[$0.tag] }))
        if filteredCategories.isEmpty {
            showAllDishes()
        } else if let allDishes = dishesViewModel.allDishes {
            dishesToShow = allDishes.filter { filteredCategories == Set($0.category) }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "ShowAddNewDishSegue":
            return
        case "ShowDishSegue":
            guard let dishViewController = segue.destination as? DishViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedDishCell = sender as? DishTableViewCell else {
                fatalError("Unexpected sender: \(sender.debugDescription)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedDishCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let dish = dishesToShow[indexPath.row]
            dishViewController.dishId = dish.id
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "unknown")")
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dishCell = tableView.dequeueReusableCell(withIdentifier: "dishCell", for: indexPath) as? DishTableViewCell else {
            fatalError("The dequeued cell is not an instance of DishTableViewCell.")
        }
        dishCell.dishTitleLabel.text = dishesToShow[indexPath.row].title
        return dishCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishesToShow.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filterViewIsVisible {
            toggleFilterView()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if filterViewIsVisible {
            toggleFilterView()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if filterViewIsVisible {
            toggleFilterView()
        }
        for categorySwitch in filterCategorySwitches {
            categorySwitch.isOn = false
        }

        if searchText.isEmpty {
            showAllDishes()
            scrollToFirstRow()
        } else if let allDishes = dishesViewModel.allDishes {
            dishesToShow = allDishes.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }

    func scrollToFirstRow() {
        if !dishesToShow.isEmpty {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}
