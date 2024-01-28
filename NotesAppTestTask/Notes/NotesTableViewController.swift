//
//  NotesTableViewController.swift
//  NotesAppTestTask
//
//  Created by Viktoriia Sharukhina on 28.01.2024.
//

import Foundation
import UIKit
import RealmSwift

class NotesTableViewController: UITableViewController {

    let realm = try! Realm()
    var folderId: ObjectId?
    
    var notes: [NoteModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNotes()
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
        cell.detailTextLabel?.text = notes?[indexPath.row].noteTitle
        
        return cell
    }

}
