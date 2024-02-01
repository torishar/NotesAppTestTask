//
//  NoteViewController.swift
//  NotesAppTestTask
//
//  Created by Viktoriia Sharukhina on 28.01.2024.
//

import UIKit
import RealmSwift

final class NoteViewController: UIViewController {
    
    var note: NoteModel?
    private let service = Service()
    var folderId: ObjectId?
    private var selectImage: UIImage?
    
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteDescription: UITextView!
    @IBOutlet weak var imageNote: UIImageView!
    @IBOutlet weak var saveNote: UIButton!
    
    @IBAction func saveNote(_ sender: Any) {
        let newNote = NoteModel()
        newNote.noteTitle = noteTitle.text ?? ""
        newNote.noteDescription = noteDescription.text ?? ""
        
        if let selectImage = selectImage {
            newNote.imageUrl = saveImageToDocumentDirectory(selectImage)
        } else {
            newNote.imageUrl = note?.imageUrl
        }
        
        if note == nil {
            if folderId != nil {
                service.createNote(folderId!, newNote)
            }
        } else {
            service.updateNote(note!, newNote: newNote)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noteDescription.text = "Note description..."
        noteDescription.delegate = self
        noteTitle.text = "Note title..."
        noteTitle.delegate = self
        
        if note != nil {
            noteTitle.text = note?.noteTitle
            noteDescription.text = note?.noteDescription
            if let imageUrl = note?.imageUrl,
               let image = loadImageFromDocumentDirectory(imageUrl) {
                imageNote.image = image
            }
        }
        
        saveNote.tintColor = UIColor(named: "font")
    }
    
    private func saveImageToDocumentDirectory(_ image: UIImage?) -> String? {
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
    
    private func loadImageFromDocumentDirectory(_ imageUrl: String) -> UIImage? {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(imageUrl)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            return nil
        }
    }

}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
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

// MARK: - UITextViewDelegate
extension NoteViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Note description..." {
            textView.text = ""
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Note description..."
        }
    }
}

// MARK: - UITextFieldDelegate
extension NoteViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "Note title..." {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            textField.text = "Note title..."
        }
    }
}
