//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    var  messsages: [Message] = [
        
    ]
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "⚡️FlashChat";
        navigationItem.hidesBackButton = true;
        tableView.dataSource = self
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        let nib = UINib(nibName: Constants.cellNibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.cellIdentifier)
        loadMessages()
        listenMessages()
    }
    
    func listenMessages() {
        db.collection(Constants.FStore.collectionName).document("SF")
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                print("Current data: \(data)")
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Firebase.Auth.auth().currentUser?.email {
            db.collection(Constants.FStore.collectionName).addDocument(data: [
                Constants.FStore.senderField: messageSender,
                Constants.FStore.bodyField: messageBody,
                Constants.FStore.dateField: NSDate().timeIntervalSince1970
            ]) { (error) in
                if(error != nil) {
                    print("fail")
                }else {
                    print("success")
                }
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut();
            navigationController?.popToRootViewController(animated: true)
        } catch let error as NSError {
            print("Error signout: %@", error)
        }
    }
    func loadMessages() {
        
        db.collection(Constants.FStore.collectionName).order(by: Constants.FStore.dateField).addSnapshotListener { [weak self](querySnapshot, err) in
            self?.messsages = []
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let documentSnapshot  = querySnapshot?.documents {
                    for document in documentSnapshot {
                        self?.messsages.append(Message(sender: document.data()[Constants.FStore.senderField] as? String ?? "", body: document.data()[Constants.FStore.bodyField] as? String ?? ""))
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messsages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        let user = messsages[indexPath.row]
        if(user.sender == Auth.auth().currentUser?.email) {
            cell.rightImageView.isHidden = true
            cell.messageBubble.isHidden = false
        }else {
            cell.rightImageView.isHidden = false
            cell.messageBubble.isHidden = true
        }
        cell.messageLabel.text = messsages[indexPath.row].body
        return cell;
    }
    
    
}
