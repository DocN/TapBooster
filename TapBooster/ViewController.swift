//
//  ViewController.swift
//  TapBooster
//
//  Created by Ryan on 2018-10-24.
//  Copyright © 2018 DrN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func SinglePlayerBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "SPViewSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}
