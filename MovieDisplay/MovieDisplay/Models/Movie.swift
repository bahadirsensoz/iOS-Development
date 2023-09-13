//
//  Movie.swift
//  MovieDisplay
//
//  Created by Ali Bahadir Sensoz on 25.07.2023.
//  

import Foundation

struct MovieResponse: Decodable {
    let results: [Movie]
}

struct Movie: Decodable{

    
    let id: Int?
    let releaseDate: String?
    let title: String?
    let voteAverage: Double?
    let backdropPath: String?
    let homepage: String?
    let runtime: Int?
    let revenue: Int?
    let originalLanguage: String?
    let overview: String?
    let genres: [MovieGenre]?
    let budget: Int?
    let credits: MovieCredit?
    let productionCompanies: [ProductionCompanies]?
    let posterPath: String?
    



    static private let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    static private let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()
    
    var backdropURL: URL{
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
    }
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    var genreText: String {
        genres?.first?.name ?? "n/a"
    }
    
    var ratingText: String {
        let rating = Int(voteAverage ?? 0.0)
        let stars = (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "★"
        }
        let ratingWithNewLine = stars + "\n\(voteAverage ?? 0.0)"
        return ratingWithNewLine
    }
    

    var scoreText: String {
        guard ratingText.count > 0 else {
            return "n/a"
        }
        return "\(ratingText.count)/10"
    }
    
    var yearText: String {
        guard let releaseDate = self.releaseDate, let date = Utils.dateFormatter.date(from: releaseDate) else {
            return "n/a"
        }
        return Movie.yearFormatter.string(from: date)
    }
    
    var durationText: String {
        guard let runtime = self.runtime, runtime > 0 else {
            return "n/a"
        }
        return Movie.durationFormatter.string(from: TimeInterval(runtime) * 60) ?? "n/a"
    }
    
    var cast: [MovieCast]? {
        credits?.cast
    }
}



struct ProductionCompanies: Codable {
    let name: String?
    
}

struct MovieGenre: Decodable {
    
    let name: String
}

struct MovieCredit: Decodable {
    
    let cast: [MovieCast]
}

struct MovieCast: Decodable, Identifiable {
    let id: Int
    let character: String
    let name: String
}


