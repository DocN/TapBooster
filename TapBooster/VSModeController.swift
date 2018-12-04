//
//  VSModeController.swift
//  TapBooster
//
//  Created by Ryan on 2018-12-03.
//  Copyright © 2018 DrN. All rights reserved.
//

import UIKit

class VSModeController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func CreateGameBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "CreateGameSeg", sender: self)
    }
    @IBAction func ReturnMainBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "ReturnMainMenuSeg", sender: self)
    }
    
    //JoinAGameSegway
    
    @IBAction func joingame(_ sender: UIButton) {
        print("fuck off");
        self.performSegue(withIdentifier: "clickjoinagameSeg", sender: self)
    }

}
