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
    var levelScore = 0;
    var levelValue = 1;
    var levelUpCap = 50;
    
    var timeValue = 0;
    var acuracyValue = 0;
    var speed = 1.0;
    var timerCount = 1.0;

    var timer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(generateTarget), userInfo: nil, repeats: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let countTime = Timer.scheduledTimer(timeInterval: timerCount, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func generateTarget() {
        let button = UIButton();
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setImage(UIImage(named: "target.png"), for: .normal)
        let screenSize = UIScreen.main.bounds
        let btnWidth = CGFloat.random(in: 20..<(100))
        let randomXPos = CGFloat.random(in: 0..<(screenSize.width - btnWidth))
        let randomYPos = CGFloat.random(in: 300..<(screenSize.height - btnWidth))
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        button.frame = CGRect(x: randomXPos, y: randomYPos, width: btnWidth, height: btnWidth)

        self.view.addSubview(button)
        
        print("Timer fired!")
    }
    
    @objc func updateTimer() {
        timeValue=timeValue+1;
        time.text="Time: "+String(timeValue);
    }

    @objc func buttonClicked(sender : UIButton){
        scoreValue = scoreValue+1;
        levelScore = levelScore+1;
        score.text = scoreTitle+String(scoreValue);
        checkLevelUp();
        sender.isHidden = true;
    }
    
    func checkLevelUp() {
        if(levelScore >= 10) {
            levelValue=levelValue+1;
            print("Level up");
            speed=(speed/1.9);
            timer.invalidate();
            timer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(generateTarget), userInfo: nil, repeats: true)
            levelScore = 0;
        }
        level.text = "Level: "+String(levelValue);
    }
    func clearScore() {
        scoreValue = 0;
        levelValue = 0;
        timeValue = 0;
        acuracyValue = 0;
    }
}


