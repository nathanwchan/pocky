//
//  DishViewController.swift
//  pocky
//
//  Created by Nathan Chan on 8/28/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit
import SafariServices

class DishViewController: UIViewController {

    var dish: Dish?
    private let stackView = UIStackView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        guard let dish = dish else {
            return
        }
        
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
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = dish.title
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 30)
        
        stackView.addArrangedSubview(titleLabel)
        
        let categoryLabel = UILabel(frame: .zero)
        categoryLabel.text = "\(dish.category.map({ String(describing: $0) }).joined(separator: ", "))"
        categoryLabel.textColor = .black
        categoryLabel.textAlignment = .center
        categoryLabel.font = UIFont(name: "HelveticaNeue", size: 25)
        
        stackView.addArrangedSubview(categoryLabel)
        
        if let link = dish.link {
            let linkLabel = UILabel(frame: .zero)
            linkLabel.textColor = .blue
            linkLabel.textAlignment = .center
            linkLabel.font = UIFont(name: "HelveticaNeue", size: 25)
            let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
            let underlineAttributedString = NSAttributedString(string: link, attributes: underlineAttribute)
            linkLabel.attributedText = underlineAttributedString
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapLink))
            linkLabel.addGestureRecognizer(tap)
            linkLabel.isUserInteractionEnabled = true
            
            stackView.addArrangedSubview(linkLabel)
        }
        
        if let notes = dish.notes {
            let notesLabel = UILabel(frame: .zero)
            notesLabel.text = notes
            notesLabel.textColor = .black
            notesLabel.textAlignment = .center
            notesLabel.font = UIFont(name: "HelveticaNeue", size: 25)
            notesLabel.numberOfLines = 0
            
            stackView.addArrangedSubview(notesLabel)
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
        if let link = dish?.link {
            let url = URL(string: link)
            openUrlInModal(url)
        }
    }
}
