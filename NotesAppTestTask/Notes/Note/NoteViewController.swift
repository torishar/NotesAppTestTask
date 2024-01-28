//
//  NoteViewController.swift
//  NotesAppTestTask
//
//  Created by Viktoriia Sharukhina on 28.01.2024.
//

import UIKit
import RealmSwift

class NoteViewController: UIViewController {

    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteDescription: UITextView!
    var note: NoteModel?
    let service = Service()
    var folderId: ObjectId?
    
    @IBAction func saveNote(_ sender: Any) {
        let newNote = NoteModel()
        newNote.noteTitle = noteTitle.text ?? ""
        newNote.noteDescription = noteDescription.text ?? ""
        if note == nil {
            if folderId != nil {
                service.createNote(folderId!, newNote)
            }
        } else {
            service.updateNote(note!, newNote: newNote)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if note != nil {
            noteTitle.text = note?.noteTitle
            noteDescription.text = note?.noteDescription
        }
    }


}

