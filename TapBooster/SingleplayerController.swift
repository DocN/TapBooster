//
//  ViewController.swift
//  TapBooster
//
//  Created by Ryan on 2018-10-24.
//  Copyright © 2018 DrN. All rights reserved.
//

import UIKit

class SingleplayerController: UIViewController {
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var score: UILabel!
    
    var scoreValue = 0;
    var scoreTitle = "Score: ";
    var levelValue = 0;
    var timeValue = 0;
    var acuracyValue = 0;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(generateTarget), userInfo: nil, repeats: true)
    }
    @objc func generateTarget() {
        let button = UIButton();
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setImage(UIImage(named: "target.png"), for: .normal)
        let screenSize = UIScreen.main.bounds
        let randomXPos = CGFloat.random(in: 0..<(screenSize.width - 50))
        let randomYPos = CGFloat.random(in: 300..<(screenSize.height - 50))
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        button.frame = CGRect(x: randomXPos, y: randomYPos, width: 50, height: 50)

        self.view.addSubview(button)
        
        print("Timer fired!")
    }
    

    @objc func buttonClicked(sender : UIButton){
        scoreValue = scoreValue+1;
        score.text = scoreTitle+String(scoreValue);
        sender.isHidden = true;
    }
    
    func clearScore() {
        scoreValue = 0;
        levelValue = 0;
        timeValue = 0;
        acuracyValue = 0;
    }
}


