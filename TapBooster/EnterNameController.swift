//
//  EnterNameController.swift
//  TapBooster
//
//  Created by Ryan on 2018-12-03.
//  Copyright © 2018 DrN. All rights reserved.
//

import UIKit

class EnterNameController: UIViewController {
    
    @IBOutlet weak var nametextbox: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func CreateRoomBtN(_ sender: Any) {
        self.performSegue(withIdentifier: "CreateRoomSeg", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateRoomSeg" {
            // telling the compiler what type of VC the sugue.destination is
            let destinationVC = segue.destination as! WaitingRoomController
            destinationVC.player1Name = nametextbox.text!
        }
    }
    
    @IBAction func returnMainBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "ReturnMainMenuNameSeg", sender: self)
    }
}
