//
//  NewConversationTableViewController.swift
//  dontPeekMe
//
//  Created by Neil Warren on 11/24/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import UIKit

class NewConversationTableViewController: UITableViewController, UISearchResultsUpdating {
    var users = [User]()
    var filteredUsers = [User]()
    
    let cellID = "CellID"
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        self.getAllUsers()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchController.isActive && searchController.searchBar.text != ""){
            return filteredUsers.count
        }
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let user : User?
        if (searchController.isActive && searchController.searchBar.text != ""){
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        cell.textLabel?.text = user?.phoneNumber
        cell.detailTextLabel?.text = user?.email
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: self.searchController.searchBar.text!)
    }
    
    func filterContent(searchText: String){
        self.filteredUsers = self.users.filter{ user in
            let username = user.phoneNumber
            return(username.lowercased().contains(searchText.lowercased()))
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getAllUsers(){
        Authorization.instance.getAllUsers() { (errMsg, data) in
            guard errMsg == nil else{
                let alert = UIAlertController(title: "Error", message: errMsg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.users = data as! [User]
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}

class UserCell: UITableViewCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented!")
    }
}