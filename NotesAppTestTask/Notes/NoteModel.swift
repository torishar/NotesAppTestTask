//
//  NoteModel.swift
//  NotesAppTestTask
//
//  Created by Viktoriia Sharukhina on 28.01.2024.
//

import Foundation
import RealmSwift

class NoteModel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var noteTitle: String = ""
    @Persisted var noteDescription: String = ""
    @Persisted(originProperty: "notes") var assignee: LinkingObjects<FolderModel>
}
