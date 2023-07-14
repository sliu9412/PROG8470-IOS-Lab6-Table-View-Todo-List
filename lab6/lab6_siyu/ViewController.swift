//
//  ViewController.swift
//  lab6_siyu
//
//  Created by user on 2023-03-04.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var MyTableView: UITableView!
    @IBAction func AddToDo(_ sender: UIBarButtonItem) {
        present(alert, animated: true)
    }

    var alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
    var alertText = UITextField()
    var defaults = UserDefaults.standard
//    save data and reload table automatically
    var TodoThings: [String] = [] {
        didSet {
            defaults.set(TodoThings, forKey: "things")
            MyTableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoThings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = TodoThings[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            TodoThings.remove(at: indexPath.row)
        }
    }

//    initialize alert after loading
    private func InitAlert() {
        alert.addTextField(configurationHandler: {
            $0.placeholder = "Write an Item"
            self.alertText = $0
        })
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if self.alertText.text?.trimmingCharacters(in: .whitespaces) != "" {
                self.TodoThings.append(self.alertText.text!)
                self.alertText.text = ""
            }
        }))
    }

//    read stored data if UserDefault is not empty
    private func LoadData() {
        if let things = defaults.array(forKey: "things") {
            TodoThings = things as! [String]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        MyTableView.dataSource = self
        MyTableView.delegate = self
        LoadData()
        InitAlert()
    }
}
