import UIKit

protocol myCellDelegate: AnyObject {
    func cityButtonTapped(in cell: myCell)
}




class CityPageViewController: UIViewController {
    var labelName: String = ""
    
    @IBOutlet weak var cityLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(labelName)
    }
    func cityButtonTapped(in cell: myCell) {

        labelName = cell.cityButtonOut.currentTitle ?? ""
        cityLabel.text = labelName
    }
}

class myCell: UITableViewCell {
    @IBAction func cityButton(_ sender: Any) {
        delegate?.cityButtonTapped(in: self)
    }

    @IBOutlet weak var cityButtonOut: UIButton!
    @IBOutlet weak var bgButtonOut: UIButton!
    weak var delegate: myCellDelegate?


    func setCityName(_ cityName: String) {
        cityButtonOut.setTitle(cityName, for: .normal)
    }
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, myCellDelegate {
    func cityButtonTapped(in cell: myCell) {
        print("Deneme")
    }
    
    
    @IBOutlet weak var cityButtonOut: UIButton!

     @IBAction func goToDestination(_ sender: Any) {
         let destinationVC = CityPageViewController()
         destinationVC.labelName = cityButtonOut.currentTitle ?? ""
         navigationController?.pushViewController(destinationVC, animated: true)
     }

    @IBOutlet weak var tableView: UITableView!

    var selectedRowIndex: Int?
    let cityNames = ["New York", "London", "Paris", "Tokyo", "Sydney", "Rome", "Berlin", "Beijing", "Moscow", "Amsterdam", "Rio de Janeiro", "Cairo", "Stockholm", "Seoul", "Toronto", "Dubai", "Venice", "Vienna", "Barcelona", "Athens"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! myCell

        cell.textLabel?.text = "Cell \(indexPath.row + 1)"
        cell.cityButtonOut.setTitle(cityNames[indexPath.row], for: .normal) 
        cell.delegate = self
        if indexPath.row == selectedRowIndex {
            cell.backgroundColor = .yellow
        } else {
            cell.backgroundColor = .white
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let previousIndex = selectedRowIndex

   
        if previousIndex == indexPath.row {
            selectedRowIndex = nil
        } else {
            selectedRowIndex = indexPath.row
        }


        tableView.reloadRows(at: [indexPath, IndexPath(row: previousIndex ?? 0, section: indexPath.section)], with: .automatic)
    }
}

