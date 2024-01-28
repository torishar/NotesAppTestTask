//
//  Service.swift
//  NotesAppTestTask
//
//  Created by Viktoriia Sharukhina on 28.01.2024.
//

import Foundation
import RealmSwift

class Service {
    let realm = try! Realm()
    
    //MARK: - Creating a new folder
    func creatFolder (_ name: String){
        let folder = FolderModel()
        folder.nameFolder = name
        
        try! realm.write ({
            realm.add(folder)
        })
    }
    
    //MARK: - Creating a new note
    func createNote(_ folderId: ObjectId, _ note: NoteModel){
        guard let folder = realm.object(ofType: FolderModel.self, forPrimaryKey: folderId) else { return }
        try! realm.write ({
            folder.notes.append(note)
        })
    }
    
    //MARK: - Deleting a folder
    func renoveFolder(_ folder: FolderModel){
        //Delete all notes in a folder
        for note in folder.notes{
            try! realm.write({
                realm.delete(note)
            })
        }
        //Deleting a folder
        try! realm.write({
            realm.delete(folder)
        })
    }
    
    //MARK: - Deleting a note
    func remoteNote(_ note: NoteModel){
        try! realm.write({
            realm.delete(note)
        })
    }
    
    //MARK: - Update a note
    func updateNote(_ note: NoteModel, newNote: NoteModel){
        try! realm.write({
            note.noteTitle = newNote.noteTitle
            note.noteDescription = newNote.noteDescription
        })
    }
}
