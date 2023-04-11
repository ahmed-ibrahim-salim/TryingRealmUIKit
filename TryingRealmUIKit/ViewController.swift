//
//  ViewController.swift
//  TryingRealmUIKit
//
//  Created by magdy khalifa on 11/04/2023.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    
    let user = User(id: "1", name: "Mido")
    let realmManager = RealmManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        
       

    }
}

class RealmManager{
    private let realm = try! Realm()

    
    // Create
    // add An object to realmDatabase
    func addObjectToRealm(objectToAdd: Todo){
        try! realm.write {
            realm.add(objectToAdd)
        }
    }
    
    // Retrieve
    // Get all todos in the realm
    func getAllObjects()->Results<Todo>{
        return realm.objects(Todo.self)
    }
    
    private func getObjectWithFilter(){
        let todos = realm.objects(Todo.self)
        // Filter
        let todosInProgress = todos.where {
            $0.status == "InProgress"
        }
        print("A list of all todos in progress: \(todosInProgress)")

    }
    
    
    // Update
    func updateItem(todoToUpdate: Todo){
        // All modifications to a realm must happen in a write block.

        try! realm.write {
            todoToUpdate.status = "InProgress"
        }
        
    }
    
    // Delete
    func deleteItem(objectToDelete: Todo){
        // All modifications to a realm must happen in a write block.
        try! realm.write {
            // Delete the Todo.
            realm.delete(objectToDelete)
        }
    }
    
    // Observe all changes
    func startObserving(){
        
        // Retain notificationToken as long as you want to observe
        let todos = realm.objects(Todo.self)
        
        let notificationToken = todos.observe { (changes) in
            switch changes {
            case .initial: break
                // Results are now populated and can be accessed without blocking the UI
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed.
                print("Deleted indices: ", deletions)
                print("Inserted indices: ", insertions)
                print("Modified modifications: ", modifications)
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
}


class User{
    var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

class Todo: Object {
    
   @Persisted(primaryKey: true) var _id: ObjectId
   @Persisted var name: String = ""
   @Persisted var status: String = ""
    
    // if you want to add the optional Device Sync then assign an ownerId
   @Persisted var ownerId: String
    
   convenience init(name: String, ownerId: String) {
       self.init()
       self.name = name
       self.ownerId = ownerId
   }
}
