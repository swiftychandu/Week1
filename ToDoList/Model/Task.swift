//
//  Task.swift
//  ToDoList
//
//  Created by chandrasekhar yadavally on 4/9/20.
//  Copyright © 2020 chandrasekhar yadavally. All rights reserved.
//

import Foundation

class Task: Codable {
    var name: String
    var isDone: Bool
    
    init(name: String, isDone: Bool = false) {
        self.name = name
        self.isDone = isDone
    }
}
