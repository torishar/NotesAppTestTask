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
    var selectImage: UIImage?
    
    @IBAction func saveNote(_ sender: Any) {
        let newNote = NoteModel()
        newNote.noteTitle = noteTitle.text ?? ""
        newNote.noteDescription = noteDescription.text ?? ""
        newNote.imageUrl = saveImageToDocumentDirectory(selectImage)
        if note == nil {
            if folderId != nil {
                service.createNote(folderId!, newNote)
            }
        } else {
            service.updateNote(note!, newNote: newNote)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var imageNote: UIImageView!
    
    @IBAction func addImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if note != nil {
            noteTitle.text = note?.noteTitle
            noteDescription.text = note?.noteDescription
            if let imageUrl = note?.imageUrl,
               let image = loadImageFromDocumentDirectory(imageUrl) {
                imageNote.image = image
            }
        }
    }
    
    func saveImageToDocumentDirectory(_ image: UIImage?) -> String? {
        guard let image = image,
              let jpgImageData = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
        
        do {
            try jpgImageData.write(to: fileURL)
            return fileName
        } catch {
            return nil
        }
    }
    
    func loadImageFromDocumentDirectory(_ imageUrl: String) -> UIImage? {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(imageUrl)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            return nil
        }
    }

}

extension NoteViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectImage = pickedImage
            imageNote.image = pickedImage
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


