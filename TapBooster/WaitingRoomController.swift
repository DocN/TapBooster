//
//  WaitingRoomController.swift
//  TapBooster
//
//  Created by Ryan on 2018-12-03.
//  Copyright © 2018 DrN. All rights reserved.
//

import UIKit
import Firebase
class WaitingRoomController: UIViewController {
    var player1Name = "";
    var roomPassword = "";
    var readyToStart = false;
    var db: Firestore!
    var roomid = "";
    @IBOutlet weak var player1: UILabel!
    @IBOutlet weak var player2: UILabel!
    @IBOutlet weak var PasswordBut: UIButton!
    @IBOutlet weak var RoomIDBut: UIButton!
    @IBOutlet weak var startbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        player1.text = player1Name;
        roomid = String(Int.random(in: 1..<1000000));
        roomPassword = String(Int.random(in: 1000..<9999));
        db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("rooms").addDocument(data: [
            "player1": player1Name,
            "player2": "",
            "RoomID": roomid,
            "Password": roomPassword,
            "Full": false,
            "Started": false,
            "score1": 0,
            "score2": 0,
            "level1": 0,
            "level2": 0,
            "loser": "",
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        RoomIDBut.setTitle("Room ID: "+roomid, for: .normal)
        PasswordBut.setTitle("Password: "+roomPassword, for: .normal)
        
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkready), userInfo: nil, repeats: true)
    }
    @IBAction func StartGame(_ sender: Any) {
        if(readyToStart == true) {
            self.performSegue(withIdentifier: "StartGame1Seg", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartGame1Seg" {
            db.collection("rooms").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let currentRoom = (document.data()["RoomID"]) as? String;
                        if(self.roomid==currentRoom) {
                            let washingtonRef = self.db.collection("rooms").document(document.documentID)
                            // Set the "capital" field of the city 'DC'
                            washingtonRef.updateData([
                                "Started": true,
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
            // telling the compiler what type of VC the sugue.destination is
            let destinationVC = segue.destination as! VSFrameController
            destinationVC.roomID = roomid;
            destinationVC.playerOneOrTwo = true;
        }
    }
    
    @objc func checkready() {
        db.collection("rooms").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let currentRoom = document.data()["RoomID"] as? String;
                    let currentFull = document.data()["Full"] as? Bool;
                    if(currentRoom == self.roomid) {
                        if(currentFull == true) {
                            let player2Data = document.data()["player2"] as? String;
                            self.startbtn.backgroundColor = UIColor.green;
                            self.startbtn.setTitle("Ready to Start",for: .normal)
                            self.readyToStart = true;
                        self.startbtn.setTitleColor(UIColor.black,for: .normal)
                            self.player2.text = player2Data;
                        }
                    }
                }
            }
        }
    }
}
