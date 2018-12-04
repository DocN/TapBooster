//
//  JoinAGameController.swift
//  TapBooster
//
//  Created by Ryan on 2018-12-03.
//  Copyright © 2018 DrN. All rights reserved.
//

import UIKit
import Firebase

class JoinAGameController: UIViewController {
    
    @IBOutlet weak var playernamebox: UITextField!
    @IBOutlet weak var roomidbox: UITextField!
    @IBOutlet weak var passwordbox: UITextField!
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         db = Firestore.firestore()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func returnroom(_ sender: Any) {
        self.performSegue(withIdentifier: "ReturnMainSeg", sender: self)
    }
    @IBAction func joinroom(_ sender: Any) {
        guard let text = playernamebox.text, !text.isEmpty else {
            return
        }
        guard let text2 = roomidbox.text, !text.isEmpty else {
            return
        }
        guard let text3 = passwordbox.text, !text.isEmpty else {
            return
        }
        let playerName = playernamebox.text;
        let roomID = roomidbox.text;
        let password = passwordbox.text;
        db.collection("rooms").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let currentRoom = (document.data()["RoomID"]) as? String;
                    let currentPassword = (document.data()["Password"]) as? String;
                    if(roomID==currentRoom || password==currentPassword) {
                        let washingtonRef = self.db.collection("rooms").document(document.documentID)
                        
                        // Set the "capital" field of the city 'DC'
                        washingtonRef.updateData([
                            "player2": playerName!,
                            "Full": true,
                        ]) { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                            }
                        }
                        self.performSegue(withIdentifier: "JoinARoomSeg", sender: self)
                    }

                }
            }
        }
        //
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "JoinARoomSeg" {
            // telling the compiler what type of VC the sugue.destination is
            let destinationVC = segue.destination as! WaitingRoomJoinController
            destinationVC.roomid = roomidbox.text!;
        }
    }
}
    
