//
//  ViewController.swift
//  pocky
//
//  Created by Nathan Chan on 8/19/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    var ref: DatabaseReference!
    var selectedMealCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        ref.child("dishes").child("0").observeSingleEvent(of: .value, with: { (snapshot) in
            let data = snapshot.value as? [AnyObject]
            let dishes = data?.map { Dish(data: $0) }
            let a = 4
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func mealCountButtonClicked(_ sender: UIButton) {
        if let buttonText = sender.titleLabel?.text,
            let mealCount = Int(buttonText) {
            selectedMealCount = mealCount
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "ShowShuffleViewController", sender: nil)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            case "ShowShuffleViewController":
                guard let shuffleViewController = segue.destination as? ShuffleViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                shuffleViewController.mealCount = selectedMealCount
            default:
                fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "unknown")")
        }
    }
}

