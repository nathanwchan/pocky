//
//  SearchViewController.swift
//  pocky
//
//  Created by Nathan Chan on 8/31/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
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
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        
        self.cancelButton.titleEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: view.traitCollection.isIphone ? 11 : 8)
        
        self.searchBar.delegate = self
        
        dishesViewModel = DishesViewModel(networkProvider: NetworkProvider())
        dishesViewModel?.didGetAllDishes = { [weak self] _ in
            self?.showAllDishes()
        }
        
        self.searchBar.becomeFirstResponder()
        self.tableView.keyboardDismissMode = .onDrag
        
        let negativeSpacerRight = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacerRight.width = -6;
        let addNewDishButton = UIBarButtonItem(title: "Add New Dish", style: .plain, target: self, action: #selector(self.addNewDishButtonClicked(sender:)))
        navigationItem.rightBarButtonItems = [negativeSpacerRight, addNewDishButton]
    }
    
    func showAllDishes() {
        if let dishes = dishesViewModel.allDishes {
            dishesToShow = dishes
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        view.endEditing(true)
    }
    
    func addNewDishButtonClicked(sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ShowAddNewDishSegue", sender: sender)
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            showAllDishes()
            scrollToFirstRow()
        } else if let allDishes = dishesViewModel.allDishes {
            dishesToShow = allDishes.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.cancelButton.isHidden = false
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.cancelButton.isHidden = true
        }
    }
    
    func scrollToFirstRow() {
        if !dishesToShow.isEmpty {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}
