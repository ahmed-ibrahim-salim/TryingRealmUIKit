//
//  ViewController.swift
//  TryingRealmUIKit
//
//  Created by magdy khalifa on 11/04/2023.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    
    let user = User(userID: "1", name: "Mido")
    let realmManager = RealmManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        
        var list: List<Point> = List()
        let point1 = Point()
        list.append(point1)
        let point2 = Point()
        point2.name = "point 22"
        list.append(point2)

        
        let todo = Todo(name: "mido", ownerId: "1", points: list)
        
        realmManager.addObjectToRealm(objectToAdd: todo)
        
        print(realmManager.getAllObjects())
        
        
        let itemTOUpdate = realmManager.getAllObjects()
        realmManager.updateItem(todoToUpdate: itemTOUpdate[0])
        
        
//                realmManager.clearDatabase()
//        
//                print(realmManager.getAllObjects())
        
    }
}

class RealmManager{
    private let realm = try! Realm()
    
    let todos: Results<Todo>?
    var notificationToken : NotificationToken?
    
    
    init(){
        self.todos = realm.objects(Todo.self)
        startObserving()
    }
    deinit{
        notificationToken?.invalidate()
    }
    
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
        guard let todos = todos else{return}
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
    
    // Delete All
    func clearDatabase(){
        // All modifications to a realm must happen in a write block.
        let todos = realm.objects(Todo.self)
        
        for todo in todos{
            try! realm.write {
                // Delete the Todo.
                realm.delete(todo)
            }
        }
    }
    
    
    // Observe all changes
    private func startObserving(){
        
        // Retain notificationToken as long as you want to observe
        guard let todos = todos else{return}
        
        notificationToken = todos.observe { (changes) in
            switch changes {
            case .initial:
                break
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
    var userID: String = ""
    var name: String = ""
    
    init(userID: String, name: String) {
        
        self.userID = userID
        self.name = name
    }
}

class Todo: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var status: String = ""
    
    // if you want to add the optional Device Sync then assign an ownerId
    @Persisted var ownerId: String
    
    
    // A user can have many points.
    @Persisted var points: List<Point>
    
    
    // A user can have one point.
//    @Persisted var point: Point? = Point()
    
    
    convenience init(name: String, ownerId: String, points: List<Point>) {
        self.init()
        self.name = name
        self.ownerId = ownerId
        self.points = points
    }
}

// for nested objects

/*When you delete a Realm object, any embedded objects referenced by that object are deleted with it. If you want the referenced objects to persist after the deletion of the parent object, your type should not be an embedded object at all.
 */

class Point: EmbeddedObject{
    @Persisted var name: String = "point one"
}
