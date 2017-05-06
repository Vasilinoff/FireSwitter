//
//  SweetsTableViewController.swift
//  FireSwiffer
//
//  Created by Vasily on 06.05.17.
//  Copyright © 2017 Vasily. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SweetsTableViewController: UITableViewController {

    var dbRef: FIRDatabaseReference!
    var sweets = [Sweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference().child("sweet-items")
        startObservingDB()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth: FIRAuth, user: FIRUser?) in
            if let user = user {
                print("Welcome \(user.email)")
                self.startObservingDB()
            } else {
                print("You need to sign up or login first!")
            }
        })
    }
    
    func startObservingDB() {
        dbRef.observe(.value, with: { (snapshot: FIRDataSnapshot) in
            var newSweets = [Sweet]()
            
            for sweet in snapshot.children {
                let sweetObject = Sweet(snapshot: sweet as! FIRDataSnapshot )
                newSweets.append(sweetObject)
            }
            
            self.sweets = newSweets
            self.tableView.reloadData()
            
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }
    @IBAction func loginAndSignUp(_ sender: UIBarButtonItem) {
        let userAlert = UIAlertController(title: "Login/Sing Up", message: "enter email asnd password", preferredStyle: .alert)
        userAlert.addTextField { (textField: UITextField) in
            textField.placeholder = "email"
        }
        userAlert.addTextField { (textField: UITextField) in
            textField.isSecureTextEntry = true
            textField.placeholder = "password"
        }
        
        userAlert.addAction(UIAlertAction(title: "Sign in", style: .default, handler: { (action: UIAlertAction) in
            let emailTextField = userAlert.textFields!.first!
            let passwordTextField = userAlert.textFields!.last!
            
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user: FIRUser?, error: Error?) in
                if error != nil {
                    print(error?.localizedDescription)
                }
            })
        }))
        
        userAlert.addAction(UIAlertAction(title: "Sign un", style: .default, handler: { (action: UIAlertAction) in
            let emailTextField = userAlert.textFields!.first!
            let passwordTextField = userAlert.textFields!.last!
            
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user: FIRUser?, error: Error?) in
                if error != nil {
                    print(error?.localizedDescription)
                }
            })
        }))
        
        self.present(userAlert, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func addSweet(_ sender: UIBarButtonItem) {
        let sweetAlert = UIAlertController(title: "New Sweet", message: "Enter your Sweet", preferredStyle: .alert)
        sweetAlert.addTextField { (textField: UITextField) in
            textField.placeholder = "Your sweet"
        }
        sweetAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action: UIAlertAction) in
            if let sweetContent = sweetAlert.textFields?.first?.text {
                let sweet = Sweet(content: sweetContent, addedByUser: "Vasily")
                
                let sweetRef = self.dbRef.child(sweetContent.lowercased())
                
                sweetRef.setValue(sweet.toAny())
            }
        }))
        
        self.present(sweetAlert, animated: true, completion: nil)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sweets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let sweet = sweets[indexPath.row]
        
        cell.textLabel?.text = sweet.content
        cell.detailTextLabel?.text = sweet.addedByUser
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sweet = sweets[indexPath.row]
            
            sweet.itemRef?.removeValue() 
        }
    }
    

}
