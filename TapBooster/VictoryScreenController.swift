//
//  VictoryScreenController.swift
//  TapBooster
//
//  Created by Ryan on 2018-12-04.
//  Copyright © 2018 DrN. All rights reserved.
//

import UIKit

class VictoryScreenController: UIViewController {
    var lost = false;
    @IBOutlet weak var youbeat: UILabel!
    @IBOutlet weak var finalscore: UILabel!
    var youbeatText = "";
    var finalScore = 0;
    var playeryoubeat = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if(lost == false) {
            self.youbeat.text = "You Beat "+playeryoubeat+", But Still...";
        }
        else {
            self.youbeat.text = "";
        }
        self.finalscore.text = "Score: "+String(finalScore);
    }
    
    @IBAction func ReturnBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "ReturnToMainMenuSeg", sender: self)
    }
}
