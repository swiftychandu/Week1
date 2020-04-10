//
//  PersistenceManager.swift
//  ToDoList
//
//  Created by chandrasekhar yadavally on 4/10/20.
//  Copyright © 2020 chandrasekhar yadavally. All rights reserved.
//

import Foundation

enum PersistenceManager {
    
    enum keys {
        static let task = "task"
    }
    
    
   static var defaults = UserDefaults.standard
    
//    static func updateWith(task: Task, actionType: PersistenceType, completion:@escaping (ErrorMessage?) -> Void) {
//        retrieve { result in
//            switch result {
//            case .success(let tasks):
//                var retrievedTasks = tasks
//                switch actionType {
//                case .add:
//                    if task.isDone{
//                        retrievedTasks[1].insert(task, at: 0)
//                        save(tasks: retrievedTasks)
//                    } else {
//                        retrievedTasks[0].insert(task, at: 0)
//                        save(tasks: retrievedTasks)
//                    }
//                case .remove:
//                    if task.isDone {
//                        retrievedTasks[1].remove(at: <#T##Int#>)
//                    }
//                }
//
//
//            case .failure(let error): print(error)
//            }
//        }
//    }
    
    static func retrieve(completed:@escaping (Result<[[Task]], ErrorMessage>) -> Void ) {
        guard let taskData = defaults.object(forKey: keys.task) as? Data else {
            completed(.success([[Task](), [Task]()]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let resultData = try decoder.decode([[Task]].self, from: taskData)
            completed(.success(resultData))
        } catch {
            completed(.failure(.unableToDecode))
        }
    }
    
    static func save(tasks: [[Task]]) -> ErrorMessage? {
        do {
            let encoder = JSONEncoder()
            let encodedTasks = try encoder.encode(tasks)
            defaults.set(encodedTasks, forKey: keys.task)
            return nil
        } catch {
            return ErrorMessage.unableToDecode
        }
    }
}
