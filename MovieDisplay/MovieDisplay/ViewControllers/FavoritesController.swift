//
//  FavoritesController.swift
//  MovieDisplay
//
//  Created by Ali Bahadir Sensoz on 4.08.2023.
//



import UIKit
import Alamofire
import AlamofireImage



class FavoritesController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()


    var favoriteMoviesFromDatabase: [FavoriteMovie] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        favoriteMoviesFromDatabase = Database.shared.fetchAllFavoriteMovies()
        tableView.reloadData()
        refreshControl.addTarget(self, action: #selector(refreshFavorites), for: .valueChanged)
        tableView.refreshControl = refreshControl


    }
    
    @objc func refreshFavorites() {
        // Refresh your data from the database
        favoriteMoviesFromDatabase = Database.shared.fetchAllFavoriteMovies()
        tableView.reloadData()

        // End the refreshing
        refreshControl.endRefreshing()
    }
    
    var unfavedMovies: [FavoriteMovie] = []

    @IBAction func favButtonPressed(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            let selectedMovie = favoriteMoviesFromDatabase[indexPath.row]

            if let favoriteMovie = fetchFavoriteMovie(with: Int(selectedMovie.id)) {
                if Database.shared.isFavorite(favoriteMovie) {
                    if !unfavedMovies.contains(favoriteMovie) {
                        unfavedMovies.append(favoriteMovie)
                    }
                    Database.shared.removeFavoriteMovie(favoriteMovie)
                    sender.backgroundColor = .gray


                } else {
                    if let cell = tableView.cellForRow(at: indexPath) as? MovieCell, let image = cell.movieImage.image {
                        Database.shared.saveFavoriteMovie(unfavedMovies[0], image: image)
                        sender.backgroundColor = .red
                    }

                    if let index = unfavedMovies.firstIndex(of: favoriteMovie) {
                        unfavedMovies.remove(at: index)
                    }
                }
            }
        }
    }
    
    func fetchFavoriteMovie(with id: Int?) -> FavoriteMovie? {
        guard let id = id else {
            return nil
        }

        let favoriteMovies = Database.shared.fetchAllFavoriteMovies()
        return favoriteMovies.first { $0.id == id }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMoviesFromDatabase.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }

        let movie = favoriteMoviesFromDatabase[indexPath.row]
        
        print("Favorite Movie:")
        print("ID: \(movie.id)")
        print("Title: \(movie.title ?? "N/A")")
        print("Release Date: \(movie.releaseDate ?? "N/A")")
        print("Rating: \(movie.ratingText ?? "N/A")")

        cell.titleLabel.text = movie.title ?? "N/A"
        cell.releaseDateLabel?.text = movie.releaseDate ?? "N/A"
        cell.ratingLabel.text = movie.ratingText ?? "N/A"
        
        if let imageData = movie.image, let image = UIImage(data: imageData) {
            cell.movieImage.image = image
        } else {
            cell.movieImage.image = UIImage(named: "defaultImage")
        }
        
        let favoriteMovie = fetchFavoriteMovie(with: Int(movie.id))

        if let favoriteMovie = favoriteMovie {
             if Database.shared.isFavorite(favoriteMovie) {
                 cell.favButton.backgroundColor = .red
             } else {
                 cell.favButton.backgroundColor = .gray
             }
         } else {
             cell.favButton.backgroundColor = .gray
         }


        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = favoriteMoviesFromDatabase[indexPath.row]
        
        if let movieDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsController") as? MovieDetailsController {
            movieDetailsViewController.movieId = Int(selectedMovie.id)
            navigationController?.pushViewController(movieDetailsViewController, animated: true)
        }
    }
}
