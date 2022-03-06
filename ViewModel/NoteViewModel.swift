//
//  NoteViewModel.swift
//  TodoApp
//
//  Created by Joshua on 06/03/2022.
//

import Foundation

struct NoteViewModel {
    var notelist: [Note] {
        return CoreDataHelper.shared.notelist
    }

    func addNote(title: String, details: String) {
        CoreDataHelper.shared.addNote(title: title, details: details)
    }

    func editNote(title: String, details: String) {
        CoreDataHelper.shared.editNote(title: title, details: details)
    }

    func deleteNote(title: String?, details: String?) {
        guard let title = title,
              let details = details else { return }
        
        CoreDataHelper.shared.deleteNote(title: title, details: details)
    }
}
