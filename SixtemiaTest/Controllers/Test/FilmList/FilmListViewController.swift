//
//  FilmListViewController.swift
//  SixtemiaTest
//
//  Created by Apps Avantiam on 9/6/25.
//  Copyright © 2025 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit

struct FilmListViewModel {
    let title: String
    let image: String
}

class FilmListViewController: UIViewController {
    
    let data: [FilmListViewModel] = [
        FilmListViewModel(title: "Hola", image: "password"),
        FilmListViewModel(title: "Bon dia", image: "forget_password"),
        FilmListViewModel(title: "Test", image: "mail")]

    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        
                self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

                // This view controller itself will provide the delegate methods and row data for the table view.
                tableView.delegate = self
                tableView.dataSource = self
        
    }

}

extension FilmListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.data.count
        }
        
        // create a cell for each table view row
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            // Reuse or create a cell of the appropriate type.
            var cell = tableView.dequeueReusableCell(withIdentifier: "FilmListCell") as? FilmListCell
            if cell == nil {
                        tableView.register(UINib.init(nibName: "FilmListCell", bundle: nil), forCellReuseIdentifier: "FilmListCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "FilmListCell") as? FilmListCell
                    }
            // Fetch the data for the row.
            //let theData = data[indexPath.row]
                 
            // Configure the cell’s contents with data from the fetched object.
           
            cell?.configCell(title: data[indexPath.row].title, image: data[indexPath.row].image)
            return cell!
        }
        
        // method to run when table view cell is tapped
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("You tapped cell number \(indexPath.row).")
        }
    
}
