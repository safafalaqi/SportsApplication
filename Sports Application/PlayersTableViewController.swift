//
//  PlayersTableViewController.swift
//  Sports Application
//
//  Created by Safa Falaqi on 27/12/2021.
//

import UIKit
import CoreData

class PlayersTableViewController: UITableViewController {

    
    var sport:Sport?

    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
   //ADD Player
    @IBAction func addPlayer(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "NewvPlayer", message: "Add a new Player", preferredStyle: .alert)
        
        let newRowIndex = self.sport?.players?.count
        
               alert.addTextField { (textField) in
                   textField.placeholder = "Enter First and Last name"}
               alert.addTextField { (textField) in
                   textField.placeholder = "Enter Age"}
               alert.addTextField { (textField) in
                   textField.placeholder = "Enter Height"}
        
               let saveAction = UIAlertAction(title: "Save", style: .default) {
                   _ in
                   let name = alert.textFields![0]
                   let age = alert.textFields![1]
                   let height = alert.textFields![2]
                   
                   let newPlayer = Player(context: self.managedObjectContext)
                   newPlayer.playerName = name.text!
                  
                   newPlayer.age = Int32(age.text!) ?? 0
                   print(newPlayer.age)
                   newPlayer.height = height.text!
       
                   self.sport?.addToPlayers(newPlayer)
                   
                   self.savePlayer()
                   
                   let indexPath = IndexPath(row: newRowIndex!, section: 0)
                   self.tableView.insertRows(at: [indexPath], with: .automatic)
               }
               let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
                   UIAlertAction -> Void in
               }
        alert.addAction(saveAction)
               alert.addAction(cancelAction)
              present(alert, animated: true, completion: nil)

    }
    
    //UPDATE
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Player", message: "edit player", preferredStyle: UIAlertController.Style.alert)
        let player =  self.sport?.players![indexPath.row] as! Player
        
        alert.addTextField { (textField) in
            textField.text = player.playerName
        }
        alert.addTextField { (textField) in
            textField.text = String(player.age)
            
        }
        alert.addTextField { (textField) in
            textField.text = player.height
            
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default)
        {
            _ in
            player.playerName = alert.textFields![0].text
            player.age = Int32(alert.textFields![1].text!) ?? 0
            player.height = alert.textFields![2].text
            
            self.savePlayer()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    
    func savePlayer(){
        
        do {
        try managedObjectContext.save()
        print("Successfully saved")
    } catch {
        print("Error when saving: \(error)")
    }
        tableView.reloadData()
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sport?.players?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath)
        let player =  self.sport?.players![indexPath.row] as! Player
        cell.textLabel!.text = " \(player.playerName!) - Age: \(player.age ) , Height: \(player.height!)"
 
        return cell
    }
}
