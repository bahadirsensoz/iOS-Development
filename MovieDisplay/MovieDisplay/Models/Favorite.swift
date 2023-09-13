//
//  Favorite.swift
//  MovieDisplay
//
//  Created by Ali Bahadir Sensoz on 9.08.2023.
//

import Foundation


struct Favorite: Identifiable, Codable {
    var id: Int
    var title: String
    var releaseDate: String
    var backdropURL : URL
}
