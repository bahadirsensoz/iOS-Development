//
//  MovieDetailsController.swift
//  MovieDisplay
//
//  Created by Ali Bahadir Sensoz on 7.08.2023.
//

import UIKit
import Alamofire
import AlamofireImage

class MovieDetailsController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var homePageLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    var movieId: Int?
    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movieId = movieId {
            fetchMovieDetails(movieId: movieId)
            print(movieId)
        } else {
            // Handle the case when movieId is nil
        }

    }

    func fetchMovieDetails(movieId: Int) {
        MovieStore.shared.fetchMovie(id: movieId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movie):
                self.movie = movie
                print(movie)
                title = movie.title
                releaseLabel.text = movie.yearText
                overviewLabel.text = movie.overview
                revenueLabel.text = "$\(String(movie.revenue ?? 0))"
                budgetLabel.text = "$\(String(movie.budget ?? 0))"
                genreLabel.text = movie.genreText
                imageView.af.setImage(withURL: movie.backdropURL)
                runtimeLabel.text = movie.durationText
                languageLabel.text = movie.originalLanguage
                homePageLabel.text = movie.homepage
                print(movie.homepage)
                
                


                
            case .failure(let error):
                print("Error fetching movie details: \(error.localizedDescription)")
            }
        }
    }
}
