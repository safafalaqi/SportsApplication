//
//  SportsTableViewController.swift
//  Sports Application
//
//  Created by Safa Falaqi on 26/12/2021.
//

import UIKit
import CoreData

class SportsTableViewController: UITableViewController, ImagePickerPressedDelegate {
   
    var sportList:[Sport] = []
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedImage:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
              let data = try managedObjectContext.fetch(Sport.fetchRequest())
            sportList = data
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
          } catch {
              print("Error: \(error)")
          }

    }
    //ADD Sport
    @IBAction func addSport(_ sender: UIBarButtonItem) {
            // Copy everything from here down
            let alert = UIAlertController(title: "New Sport",
                                          message: "Add a new sport",
                                          preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: nil)
            
            let saveAction = UIAlertAction(title: "Save", style: .default)
            {
                _ in
                let textField = alert.textFields![0]
                let newEntry = Sport(context: self.managedObjectContext)
                newEntry.sportName = textField.text!
                self.saveSport()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    //Save sport
    func saveSport() {
           do {
               try managedObjectContext.save()
               print("Successfully saved")
           } catch {
               print("Error when saving: \(error)")
           }
        fetchSports()
       }
    
    func fetchSports() {
        do {
            sportList = try managedObjectContext.fetch(Sport.fetchRequest())
            print("Success")
        } catch {
            print("Error: \(error)")
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sportList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sportsCell", for: indexPath) as! SportsTableViewCell

        cell.sportLabel.text = sportList[indexPath.row].sportName
        cell.indexPath = indexPath
        
        if let img = sportList[indexPath.row].sportImage {
            
            let i = UIImage(data:img)
            let sized = i!.resizedImage(Size: CGSize(width: 100, height: 100))
            cell.imageBt.setImage(sized, for: .normal)
            cell.imageBt.setTitle("", for: .normal)
        
            
        }
        cell.delegate = self
        return cell
    }
    
    
   
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let sport = sportList[indexPath.row]
        performSegue(withIdentifier: "sportSegue", sender: sport)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sportSegue" {
                    let playersTableViewController = segue.destination as! PlayersTableViewController
            playersTableViewController.sport = sender as! Sport
            playersTableViewController.title = playersTableViewController.sport?.sportName
            }
    }

    func addImage(indexPath:IndexPath) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true )
        selectedImage = indexPath
  
    }
    //UPDATE
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Edit Sport", message: "edit sport", preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField(configurationHandler: nil)
        
        let saveAction = UIAlertAction(title: "Save", style: .default)
        {
            _ in
            let textField = alert.textFields![0]
            self.sportList[indexPath.row].sportName = textField.text
            self.saveSport()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    //DELETE
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         managedObjectContext.delete(sportList[indexPath.row])
         self.saveSport()
    }
    

}

extension SportsTableViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

            let cell:SportsTableViewCell = tableView.cellForRow(at: IndexPath(row: selectedImage!.row, section: 0)) as! SportsTableViewCell
            
            let img = image.resizedImage(Size: CGSize(width: 100, height: 100))
            cell.imageBt.setImage(img, for: .normal)
            cell.imageBt.setTitle("", for: .normal)
            sportList[selectedImage!.row].sportImage =  img?.pngData()
            saveSport()
        }

        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UIImage
{
    func resizedImage(Size sizeImage: CGSize) -> UIImage?
    {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: sizeImage.width, height: sizeImage.height))
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        self.draw(in: frame)
        let resizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.withRenderingMode(.alwaysOriginal)
        return resizedImage
    }
}
