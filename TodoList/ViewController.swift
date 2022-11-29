//
//  ViewController.swift
//  TodoList
//
//  Created by 1 on 2022/11/29.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet var editButton: UIBarButtonItem!
    var doneButton : UIBarButtonItem?
    
    //할일 저장하는 배열
    var tasks = [Task]() {
        didSet {
            self.saveTasks()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableVIew.dataSource = self
        self.tableVIew.delegate = self
        self.loadTasks()
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))
    }
    
    @objc func doneButtonTap(_ sender: UIBarButtonItem) {
        guard !self.tasks.isEmpty else { return }
        self.navigationItem.leftBarButtonItem = self.editButton
        
    }

    @IBAction func tapEditButton(_ sender: Any) {
    }
    
    
    @IBAction func tapAddButton(_ sender: Any) {
        let alert = UIAlertController(title: "할일", message: "할일등록", preferredStyle: .alert)
        let registerButton = UIAlertAction(title: "등록", style: .default, handler: { [weak self] _ in
            guard let title = alert.textFields?[0].text else { return }
            let task = Task(title: title, done: false)
            self?.tasks.append(task)
            self?.tableVIew.reloadData()
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancelButton)
        alert.addAction(registerButton)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "할 일을 입력해주세요"
            
        })
        self.present(alert, animated: true)
    }
    
    func saveTasks() {
        let data = self.tasks.map {
            [
                "title": $0.title,
                "done": $0.done
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")
    }
    
    func loadTasks() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
        self.tasks = data.compactMap{
            guard let title = $0["title"] as? String else { return nil }
            guard let done = $0["done"] as? Bool else { return nil }
            return Task(title: title, done: done)
        }
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = self.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        if task.done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
   
    
}



extension ViewController: UITableViewDelegate {
    // 체크
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = self.tasks[indexPath.row]
        task.done = !task.done
        self.tasks[indexPath.row] = task
        self.tableVIew.reloadRows(at: [indexPath], with: .automatic)
    }
}
