//
//  VSFrameController.swift
//  TapBooster
//
//  Created by Ryan on 2018-12-04.
//  Copyright © 2018 DrN. All rights reserved.
//

import UIKit
import Firebase

class VSFrameController: UIViewController {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var score: UILabel!
    
    @IBOutlet weak var player1: UILabel!
    @IBOutlet weak var player2: UILabel!
    
    @IBOutlet weak var level2: UILabel!
    @IBOutlet weak var score2: UILabel!
    var playerOneName = "";
    var playerTwoname = "";
    var db: Firestore!
    var scoreValue = 0;
    var scoreTitle = "Score: ";
    var levelScore = 0;
    var levelValue = 1;
    var levelUpCap = 50;
    
    var timeValue = 0;
    var acuracyValue = 0;
    var speed = 1.0;
    var timerCount = 1.0;
    var timer = Timer();
    var roomID = "";
    var yourCircles = 0;
    var lost = false;
    
    //true = 1 false= 2
    var playerOneOrTwo = true;
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        getCurrentData();
        // Do any additional setup after loading the view, typically from a nib.
        timer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(generateTarget), userInfo: nil, repeats: true)
        let countTime = Timer.scheduledTimer(timeInterval: timerCount, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func getCurrentData() {
        db.collection("rooms").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let currentRoom = document.data()["RoomID"] as? String;
                    if(currentRoom == self.roomID) {
                        let currentPlayer1 = document.data()["player1"] as? String;
                        self.player1.text = currentPlayer1;
                        self.playerOneName = currentPlayer1!;
                        let currentPlayer2 = document.data()["player2"] as? String;
                        self.player2.text = currentPlayer2;
                        self.playerTwoname = currentPlayer2!;
                        if(self.playerOneOrTwo) {
                            let currentScore2 = document.data()["score2"] as? NSNumber;
                            self.score2.text = "Score: "+(currentScore2?.stringValue)!
                            let currentLevel2 = document.data()["level2"] as? NSNumber;
                            self.level2.text = "Level: "+(currentLevel2?.stringValue)!
                        } else {

                            let currentScore1 = document.data()["score1"] as? NSNumber;
                            self.score.text = "Score: "+(currentScore1?.stringValue)!
                            let currentLevel1 = document.data()["level1"] as? NSNumber;
                            self.level.text = "Level: "+(currentLevel1?.stringValue)!
                        }
                    }
                }
            }
        }
    }
    @objc func generateTarget() {
        let button = UIButton();
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setImage(UIImage(named: "target.png"), for: .normal)
        let screenSize = UIScreen.main.bounds
        let btnWidth = CGFloat.random(in: 20..<(100))
        let randomXPos = CGFloat.random(in: 0..<(screenSize.width - btnWidth))
        let randomYPos = CGFloat.random(in: 200..<(screenSize.height - btnWidth))
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        self.yourCircles = self.yourCircles+1;
        button.frame = CGRect(x: randomXPos, y: randomYPos, width: btnWidth, height: btnWidth)
        
        self.view.addSubview(button)
        
        print("Timer fired!")
        if(self.yourCircles >= 15) {
            db.collection("rooms").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                }
                else {
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let currentRoom = (document.data()["RoomID"]) as? String;
                        if(self.roomID==currentRoom) {
                            let washingtonRef = self.db.collection("rooms").document(document.documentID)
                            let loser = document.data()["loser"] as? String;
                            if(loser=="") {
                                if(self.playerOneOrTwo == false) {
                                    // Set the "capital" field of the city 'DC'
                                    washingtonRef.updateData([
                                        "loser": self.playerTwoname
                                    ]) { err in
                                        if let err = err {
                                            print("Error updating document: \(err)")
                                        } else {
                                            print("Document successfully updated")
                                        }
                                    }
                                    self.lost = true;
                                }
                                else {
                                    // Set the "capital" field of the city 'DC'
                                    washingtonRef.updateData([
                                        "loser": self.playerOneName
                                    ]) { err in
                                        if let err = err {
                                            print("Error updating document: \(err)")
                                        } else {
                                            print("Document successfully updated")
                                        }
                                    }
                                    self.lost = true;
                                }
                            }
                            else {
                                self.performSegue(withIdentifier: "VictorySegway", sender: self)
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VictorySegway" {
            // telling the compiler what type of VC the sugue.destination is
            let destinationVC = segue.destination as! VictoryScreenController
            print(self.lost);
            destinationVC.lost = self.lost;
            destinationVC.finalScore = self.scoreValue;
            if(playerOneOrTwo) {
                destinationVC.playeryoubeat = self.playerTwoname
            }
            else {
                destinationVC.playeryoubeat = self.playerOneName
            }
            
        }
    }
    
    
    @objc func updateTimer() {
        timeValue=timeValue+1;
        self.getCurrentData();
        time.text="Time: "+String(timeValue);
    }
    
    @objc func buttonClicked(sender : UIButton){
        scoreValue = scoreValue+1;
        levelScore = levelScore+1;
        self.yourCircles = self.yourCircles-1;
        if(playerOneOrTwo) {
            score.text = scoreTitle+String(scoreValue);
        }
        else {
            score2.text = scoreTitle+String(scoreValue);
        }
        
        checkLevelUp();
        sender.isHidden = true;
        db.collection("rooms").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let currentRoom = (document.data()["RoomID"]) as? String;
                    if(self.roomID==currentRoom) {
                        let washingtonRef = self.db.collection("rooms").document(document.documentID)
                        if(self.playerOneOrTwo == false) {
                            // Set the "capital" field of the city 'DC'
                            washingtonRef.updateData([
                                "score2": self.scoreValue,
                                "level2": self.levelValue,
                                ]) { err in
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("Document successfully updated")
                                    }
                            }
                        }
                        else {
                            // Set the "capital" field of the city 'DC'
                            washingtonRef.updateData([
                                "score1": self.scoreValue,
                                "level1": self.levelValue,
                                ]) { err in
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("Document successfully updated")
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func checkLevelUp() {
        if(levelScore >= 10) {
            levelValue=levelValue+1;
            print("Level up");
            speed=(speed/1.05);
            timer.invalidate();
            timer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(generateTarget), userInfo: nil, repeats: true)
            levelScore = 0;
        }
        if(playerOneOrTwo) {
            level.text = "Level: "+String(levelValue);
        }
        else {
            level2.text = "Level: "+String(levelValue);
        }
    }
    func clearScore() {
        scoreValue = 0;
        levelValue = 0;
        timeValue = 0;
        acuracyValue = 0;
    }
}



