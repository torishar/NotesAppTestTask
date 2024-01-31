//
//  FolderModel.swift
//  NotesAppTestTask
//
//  Created by Viktoriia Sharukhina on 28.01.2024.
//

import Foundation
import RealmSwift

class FolderModel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var nameFolder: String = ""
    @Persisted var notes: List<NoteModel>
}
