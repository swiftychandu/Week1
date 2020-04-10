//
//  TaskStore.swift
//  ToDoList
//
//  Created by chandrasekhar yadavally on 4/9/20.
//  Copyright © 2020 chandrasekhar yadavally. All rights reserved.
//

import Foundation

class TaskStore {
    var tasks = [[Task](), [Task]()]
    
    func add(task: Task, at ind: Int, isDone: Bool = false) {
        let section = isDone ? 1 : 0
        tasks[section].insert(task, at: ind)
    }
    
  @discardableResult  func remove(at index: Int, isDone: Bool = false) -> Task {
        let section = isDone ? 1 : 0
        return tasks[section].remove(at: index)
    }
}
