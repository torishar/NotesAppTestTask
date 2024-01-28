//
//  FoldersTableViewController.swift
//  NotesAppTestTask
//
//  Created by Viktoriia Sharukhina on 28.01.2024.
//

import Foundation
import UIKit
import RealmSwift

class FoldersTableViewController: UITableViewController {
    
    var alert = UIAlertController()
    let realm = try! Realm()
    var folders: [FolderModel]?
    let service = Service()

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllFolders()
    }
    
    private func getAllFolders(){
        self.folders = Array(realm.objects(FolderModel.self))
        tableView.reloadData()
    }
    
    
    @IBAction func addFolder(_ sender: Any) {
        alertAction()
        present(alert, animated: true)
    }
    
    private func alertAction() {
        alert = UIAlertController(title: "Add folder", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Folder name"
        }
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { action in
            if let text = self.alert.textFields?[0].text {
                self.service.creatFolder(text)
                self.getAllFolders()
            }
        }
        
        alert.addAction(alertAction)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "folder", for: indexPath)
        cell.textLabel?.text = folders?[indexPath.row].nameFolder
        cell.detailTextLabel?.text = "\(folders?[indexPath.row].notes.count)"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNotes", let dest = segue.destination as? NotesTableViewController, let selectFolderIndex = tableView.indexPathForSelectedRow {
            let selectFolder = folders?[selectFolderIndex.row].id
            dest.folderId = selectFolder
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let folder = folders?[indexPath.row]{
                service.renoveFolder(folder)
                folders?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showNotes", sender: nil)
    }
}
