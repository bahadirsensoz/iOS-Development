//
//  ViewController.swift
//  ThirdAssignment
//
//  Created by Ali Bahadir Sensoz on 20.07.2023.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    
    var tvSeriesManager = TvSeriesManager()
    var tvSeriesData: [TVDataModel] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        //print(searchTextField.text!)
        searchTextField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let tvSeriesName = searchTextField.text {
            tvSeriesManager.fetchTvSeries(tvSeriesName: tvSeriesName)
        }
        searchTextField.text = ""
    }

    // A helper method to reload the table view after data is fetched and parsed
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didUpdateTVSeriesData() {

        tvSeriesData.removeAll()
        tableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return tvSeriesData.count
      }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TvSeriesCell", for: indexPath) as! TvSeriesCell
        let tvSeries = tvSeriesData[indexPath.row]

        // Configure the cell with TV show data
        cell.titleLabel.text = tvSeries.show?.name
        cell.typeLabel.text = tvSeries.show?.type
        cell.setImage(urlString: tvSeries.show?.image?.original)

        return cell
    }
}
