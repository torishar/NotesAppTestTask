//
//  NotesTableViewController.swift
//  NotesAppTestTask
//
//  Created by Viktoriia Sharukhina on 28.01.2024.
//

import Foundation
import UIKit
import RealmSwift

final class NotesTableViewController: UITableViewController {

    let realm = try! Realm()
    var folderId: ObjectId?
    var service = Service()
    var notes: [NoteModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNotes()
        
        if let folderName = realm.object(ofType: FolderModel.self, forPrimaryKey: folderId)?.nameFolder {
            navigationItem.title = folderName
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNotes()
    }
    
    
    @IBAction func addNewNote(_ sender: Any) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addNewNote") as? NoteViewController {
            viewController.folderId = folderId
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func getNotes() {
        if let folder = realm.object(ofType: FolderModel.self, forPrimaryKey: folderId) {
            self.notes = Array(folder.notes)
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath)
        cell.textLabel?.text = notes?[indexPath.row].noteTitle
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let note = notes?[indexPath.row]{
                service.remoteNote(note)
                notes?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addNewNote") as? NoteViewController {
            viewController.folderId = folderId
            viewController.note = notes?[indexPath.row]
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
