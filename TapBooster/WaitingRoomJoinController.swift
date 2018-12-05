//
//  WaitingRoomJoinController.swift
//  TapBooster
//
//  Created by Ryan on 2018-12-04.
//  Copyright © 2018 DrN. All rights reserved.
//

import UIKit
import Firebase
class WaitingRoomJoinController: UIViewController {
    var roomPassword = "";
    var db: Firestore!
    var roomid = "";
    @IBOutlet weak var player1: UILabel!
    @IBOutlet weak var player2: UILabel!
    @IBOutlet weak var PasswordBut: UIButton!
    @IBOutlet weak var RoomIDBut: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        db = Firestore.firestore()
        
        db.collection("rooms").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let currentRoom = document.data()["RoomID"] as? String;
                    let currentPassword = document.data()["Password"] as? String;
                    if(currentRoom==self.roomid) {
                        self.player1.text = document.data()["player1"] as? String;
                        self.player2.text = document.data()["player2"] as? String;
                        self.RoomIDBut.setTitle("Room ID: "+self.roomid, for: .normal)
                        self.PasswordBut.setTitle("Password: "+currentPassword!, for: .normal)
                    }
                }
            }
        }


        RoomIDBut.setTitle("Room ID: "+roomid, for: .normal)
        PasswordBut.setTitle("Password: "+roomPassword, for: .normal)
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkready), userInfo: nil, repeats: true)
    }
    @objc func checkready() {
        db.collection("rooms").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let currentRoom = document.data()["RoomID"] as? String;
                    let currentStarted = document.data()["Started"] as? Bool;
                    if(currentRoom == self.roomid) {
                        if(currentStarted == true) {
                            self.performSegue(withIdentifier: "JoinAGameSegway", sender: self)
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "JoinAGameSegway" {
            // telling the compiler what type of VC the sugue.destination is
            let destinationVC = segue.destination as! VSFrameController
            destinationVC.roomID = roomid;
            destinationVC.playerOneOrTwo = false;
        }
    }
}
