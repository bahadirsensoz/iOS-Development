//
//  TVData.swift
//  ThirdAssignment
//
//  Created by Ali Bahadir Sensoz on 21.07.2023.
//

import Foundation

struct TVDataModel: Decodable {
    let show: Show?
    
}

struct Show: Decodable {
    let name: String?
    let type: String?
    let image: Image?
}

struct Image: Decodable {
    let original: String?
}
