//
//  ShuffleViewController.swift
//  pocky
//
//  Created by Nathan Chan on 8/21/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

class ShuffleViewController: UIViewController {

    @IBOutlet weak var mealCountLabel: UILabel!
    var mealCount: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealCountLabel.text = String(describing: mealCount)
    }
}
