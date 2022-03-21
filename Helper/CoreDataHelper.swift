//
//  CoreDataHelper.swift
//  TodoApp
//
//  Created by Joshua on 06/03/2022.
//

import CoreData
import Foundation

struct CoreDataHelper {
    static let shared = CoreDataHelper()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoApp")
        
        container.loadPersistentStores { description, error in
            // if error exists, crash
            if let error = error {
                fatalError("Something went wrong. We were unable to load the peristent stores. Error: \(error.localizedDescription)")
            }
        }
        
        return container
    }()
    
    var notelist: [Note] {
        do {
            return try persistentContainer.viewContext.fetch(NSFetchRequest<Note>(entityName: "Note"))
        } catch let error {
            print("Unable to retrieve list items \(error.localizedDescription)")
            return []
        }
    }
    
    func addNote(title: String, details: String) {
        let listItem = NSEntityDescription.insertNewObject(forEntityName: "Note", into: persistentContainer.viewContext) as? Note
        
        listItem?.setValue(title, forKey: "title")
        listItem?.setValue(details, forKey: "details")
        
        save()
    }
    
    func editNote(title: String, details: String) {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@",
                                                 argumentArray: ["title", title,
                                                                 "details", details])
        do {
            guard let listItem = try persistentContainer.viewContext.fetch(fetchRequest).first else {
                // item doesn't exist in core data
                return
            }
            
            // delete it
            listItem.setValue(title, forKey: "title")
            listItem.setValue(details, forKey: "details")
            save()
        } catch let error {
            print("Unable to edit for name \(title) and details \(details). Error:", error.localizedDescription)
        }
        
        save()
    }
    
    func deleteNote(title: String, details: String) {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@",
                                             argumentArray: ["title", title,
                                                             "details", details])
        
        do {
            guard let listItem = try persistentContainer.viewContext.fetch(fetchRequest).first else {
                // item doesn't exist in core data
                return
            }
            
            // delete it
            persistentContainer.viewContext.delete(listItem)
            save()
        } catch let error {
            print("Unable to delete list item with title \(title). Error:", error.localizedDescription)
        }
    }
    
    private func save() {
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print("Unable to save. Error:", error.localizedDescription)
        }
    }
}

