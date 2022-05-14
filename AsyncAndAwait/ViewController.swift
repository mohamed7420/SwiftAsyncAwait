//
//  ViewController.swift
//  AsyncAndAwait
//
//  Created by Mohamed osama on 07/05/2022.
//

import UIKit

struct User: Decodable{
    let name: String
    let username: String
}

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
   
    var users = [User]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        Task{
            let users = try await fetchUsers()
            self.users = users ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchUsers() async throws -> [User]?{
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            return []
        }
        
        if #available(iOS 15.0, *) {
            let (data , _) = try await URLSession.shared.data(from: url , delegate: nil)
            let users = try? JSONDecoder().decode([User].self, from: data)
            return users
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let name = users[indexPath.row].name
        cell.textLabel?.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

}

