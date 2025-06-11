import UIKit

struct ApiCallVModel {
    let title: String
    let image: String
}

class ApiCallVC: UIViewController {
    var apiResult = [Model]()
    
    let data: [ApiCallVModel] = [
        ApiCallVModel(title: "Hola", image: "password"),
        ApiCallVModel(title: "Bon dia", image: "forget_password"),
        ApiCallVModel(title: "Test", image: "mail")]

    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var apiDataView: UITableView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        APIFetchHandler.sharedInstance.fetchAPIData{ apiData in
            self.apiResult = apiData
            
            DispatchQueue.main.async {
                self.apiDataView.reloadData()
            }
        }
        
                self.apiDataView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

                // This view controller itself will provide the delegate methods and row data for the table view.
            apiDataView.delegate = self
            apiDataView.dataSource = self
        
    }

}

extension ApiCallVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiResult.count
        }
        
        // create a cell for each table view row
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            /*
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                 else {
                   return UITableViewCell()
                }
                cell.textLabel?.text = apiResult[indexPath.row].title
                return cell
            */
            
            // Reuse or create a cell of the appropriate type.
            var cell = tableView.dequeueReusableCell(withIdentifier: "FilmListCell"
                                                     ) as? FilmListCell
            if cell == nil {
                        tableView.register(UINib.init(nibName: "FilmListCell", bundle: nil), forCellReuseIdentifier: "FilmListCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "FilmListCell") as? FilmListCell
                    }
            // Fetch the data for the row.
            cell?.selectionStyle = .none

            // Configure the cell’s contents with data from the fetched object.
           
            cell?.configCell(title: apiResult[indexPath.row].title, image: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/Anas_platyrhynchos_qtl1.jpg/1200px-Anas_platyrhynchos_qtl1.jpg")
            return cell!
        }
        
        // method to run when table view cell is tapped
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("You tapped cell number \(indexPath.row).")
            let destination = ApiDetailVC() // Your destination
            navigationController?.pushViewController(destination, animated: true)
            
            destination.apiTitle = apiResult[indexPath.row].title
            destination.apiBody = apiResult[indexPath.row].body
        }
    
}
