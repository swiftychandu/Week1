//
//  TasksViewController.swift
//  ToDoList
//
//  Created by chandrasekhar yadavally on 4/9/20.
//  Copyright © 2020 chandrasekhar yadavally. All rights reserved.
//

import UIKit

class TasksViewController: UITableViewController {
 
    var taskStore: TaskStore! {
        didSet {
            PersistenceManager.retrieve { (result) in
                switch result {
                case .success(let tasks): self.taskStore.tasks = tasks
                case .failure(let error): print(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
       
    }
    
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add new task", message: nil, preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let name = alertController.textFields?.first?.text else { return }
            let newTask = Task(name: name)
            self.taskStore.add(task: newTask, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            _ = PersistenceManager.save(tasks: self.taskStore.tasks)
        }
        addAction.isEnabled = false
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter a task name"
            textField.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
        }
        alertController.addAction(addAction)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    @objc func handleTextChanged(_ sender: UITextField) {
        guard let alertController = presentedViewController as? UIAlertController,
            let addAction = alertController.actions.first,
            let text = sender.text else { return }
        addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
         taskStore.tasks.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return taskStore.tasks[section].count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        cell.textLabel?.text = taskStore.tasks[indexPath.section][indexPath.row].name

        return cell
    }

   
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: nil) { action, sourceView, completion in
            self.taskStore.tasks[0][indexPath.row].isDone = true
            let doneTask = self.taskStore.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.taskStore.add(task: doneTask, at: 0, isDone: true)
            tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            _ = PersistenceManager.save(tasks: self.taskStore.tasks)
            completion(true)
        }
        doneAction.image = UIImage(named: "done")
        doneAction.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]): nil
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { action, sourceView, completion in
            
        let isDone = self.taskStore.tasks[indexPath.section][indexPath.row].isDone
            self.taskStore.remove(at: indexPath.row, isDone: isDone)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            _ = PersistenceManager.save(tasks: self.taskStore.tasks)
            completion(true)
        }
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           55
       }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "To-Do" : "Done"
    }
}


