//
//  TableViewController.swift
//  NotificationApp
//
//  Created by A Ab. on 27/05/1443 AH.
//

import UIKit

class TableViewController: UITableViewController {
    
    var allNotifications: [LocalNotification]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        tableView.separatorColor = .black

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  allNotifications?.count ?? 0

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let allNotifications = allNotifications else {
            return cell
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        let timeStarted = formatter.string(from: allNotifications[indexPath.row].dateItStarted)
        let timeEnded = formatter.string(from: allNotifications[indexPath.row].dateItEnds)

        cell.textLabel?.text = "\(timeStarted) - \(timeEnded) ... \(allNotifications[indexPath.row].length) minute timer"
        
    
        

        return cell
    }

}
