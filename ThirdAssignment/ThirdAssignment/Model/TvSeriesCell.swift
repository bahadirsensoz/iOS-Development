//
//  tvSeriesCell.swift
//  ThirdAssignment
//
//  Created by Ali Bahadir Sensoz on 21.07.2023.
//

import Foundation
import UIKit

class TvSeriesCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var showImageView: UIImageView!

    func setImage(urlString: String?) {
        if let urlString {
            if let  url = URL(string: urlString) {
                
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self?.showImageView.image = UIImage(data: data)
                        }
                    }
                }
            }
            
        }
        
    }
}
