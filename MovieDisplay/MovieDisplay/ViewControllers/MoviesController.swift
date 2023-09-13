    //
    //  ViewController.swift
    //  MovieDisplay
    //
    //  Created by Ali Bahadir Sensoz on 25.07.2023.
    //


    import Alamofire
    import AlamofireImage
    import UIKit
    import CoreData

    class MoviesController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
        
        var movies = [Movie]()
        var currentPage = 1
        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var searchBar: UISearchBar!
        var isFetchingData = false
        var isEndOfData = false
        var tapGestureView: UIView?
        var isKeyboardActive = false
        var context: NSManagedObjectContext {
            return Database.shared.persistentContainer.viewContext
        }
        
        var refreshControl = UIRefreshControl()

        
        
        var favoriteMoviesFromDatabase: [Movie] = []


        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            tableView.dataSource = self
            searchBar.delegate = self
            tapGestureView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 0))
            tapGestureView?.backgroundColor = .clear
            view.addSubview(tapGestureView!)

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGestureView?.addGestureRecognizer(tapGesture)
            tapGestureView?.isUserInteractionEnabled = false
            refreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
            tableView.refreshControl = refreshControl
            
            fetchPopularMovies()
            
            
        }

        @objc func refreshMovies() {
            currentPage = 1
            movies.removeAll()
            fetchPopularMovies()
        }
        
        
        @IBAction func favButtonPressed(_ sender: UIButton) {
            let point = sender.convert(CGPoint.zero, to: tableView)
            if let indexPath = tableView.indexPathForRow(at: point) {
                let selectedMovie = movies[indexPath.row]
                
                if let favoriteMovie = fetchFavoriteMovie(with: selectedMovie.id, context: context) {
                    Database.shared.removeFavoriteMovie(favoriteMovie)
                    sender.backgroundColor = .gray
                } else {
                    if let cell = tableView.cellForRow(at: indexPath) as? MovieCell, let image = cell.movieImage.image {
                        if let newFavoriteMovie = createFavoriteMovie(from: selectedMovie, context: context, image: image) {
                            sender.backgroundColor = .red
                        } else {
                            return
                        }
                    } else {
                        return
                    }
                }
            }
        

                
               
            let favoriteMovies = Database.shared.fetchAllFavoriteMovies()
                
                for favoriteMovie in favoriteMovies {
                    print("Favorite Movie:")
                    print("ID: \(favoriteMovie.id)")
                    print("Title: \(favoriteMovie.title ?? "N/A")")
                    print("Release Date: \(favoriteMovie.releaseDate ?? "N/A")")
                    print("Rating: \(favoriteMovie.ratingText ?? "N/A")")
                    
                    if let imageData = favoriteMovie.image, let image = UIImage(data: imageData) {
                        print("Image Size: \(image.size)")
                    }
                }
            }
        



        func fetchFavoriteMovie(with id: Int?, context: NSManagedObjectContext) -> FavoriteMovie? {
            guard let id = id else {
                return nil
            }
            
            let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            
            do {
                let favorites = try context.fetch(fetchRequest)
                return favorites.first
            } catch {
                print("Error fetching favorite movie: \(error.localizedDescription)")
                return nil
            }
        }
        
        func createFavoriteMovie(from movie: Movie, context: NSManagedObjectContext, image: UIImage) -> FavoriteMovie? {
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "FavoriteMovie", in: context) else {
                return nil
            }
            
            let newFavoriteMovie = FavoriteMovie(entity: entityDescription, insertInto: context)
            newFavoriteMovie.id = Int32(movie.id ?? 0)
            newFavoriteMovie.title = movie.title
            newFavoriteMovie.releaseDate = movie.yearText
            newFavoriteMovie.ratingText = movie.ratingText
            
            newFavoriteMovie.image = image.jpegData(compressionQuality: 0.8)
            do {
                try context.save()
            } catch {
                print("Failed to save favorite movie: \(error.localizedDescription)")
            }
            return newFavoriteMovie
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

            tapGestureView?.isUserInteractionEnabled = true
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            tapGestureView?.isUserInteractionEnabled = false
            searchBar.resignFirstResponder()
        }
        
        
        func fetchNextPage() {
            guard !isFetchingData && !isEndOfData else {
                return
            }
            isFetchingData = true
            
            MovieStore.shared.fetchMovies(from: .popular, page: currentPage) { [weak self] result in
                guard let self = self else { return }
                
                self.isFetchingData = false
                
                switch result {
                case .success(let movieResponse):
                    if !movieResponse.results.isEmpty {
                        self.movies += movieResponse.results
                        print("Fetched \(self.movies.count) more movies.")
                        self.tableView.reloadData()
                    } else {
                        self.isEndOfData = true
                    }
                case .failure(let error):
                    print("Error fetching more movies: \(error.localizedDescription)")
                }
            }
        }
        
        @objc func dismissKeyboard() {
            searchBar.resignFirstResponder()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performSearch), object: nil)
            perform(#selector(performSearch), with: nil, afterDelay: 0.5)
        }
        
        
        @objc func performSearch() {
            guard let searchText = searchBar.text, !searchText.isEmpty else {
                currentPage = 1
                movies.removeAll()
                fetchPopularMovies()
                return
            }
            self.tableView.reloadData()

            MovieStore.shared.searchMovie(query: searchText) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let movieResponse):
                    self.movies = movieResponse.results
                    if !self.movies.isEmpty {
                        print("Fetched \(self.movies.count) movies for search query: \(searchText)")
                    } else {
                        print("No movies found for search query: \(searchText)")
                    }
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error searching movies: \(error.localizedDescription)")
                }
            }
        }
        
        func fetchPopularMovies() {
            guard !isFetchingData && !isEndOfData else {
                return
            }
            isFetchingData = true
            
            MovieStore.shared.fetchMovies(from: .popular, page: currentPage) { [weak self] result in
                    guard let self = self else { return }
                    
                    self.isFetchingData = false
                    
                    switch result {
                    case .success(let movieResponse):
                        if !movieResponse.results.isEmpty {
                            self.movies += movieResponse.results
                            print("Fetched \(self.movies.count) popular movies.")
                            self.tableView.reloadData()
                        } else {
                            self.isEndOfData = true
                        }
                    case .failure(let error):
                        print("Error fetching popular movies: \(error.localizedDescription)")
                    }
                    
                    self.refreshControl.endRefreshing()
                }
            }
        
        
        
        
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return movies.count
        }
        
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row == movies.count - 1 {
                if searchBar.text?.isEmpty == true {
                    if indexPath.row == movies.count - 1 {
                        currentPage += 1
                        fetchNextPage()
                    }
                }
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
                
                return UITableViewCell()
            }

            let movie = movies[indexPath.row]
            

            if movie.title != nil {
                cell.titleLabel.text = movies[indexPath.row].title
            } else {
                cell.titleLabel.text = "N/A"
            }
            
            cell.releaseDateLabel?.text = movie.yearText
            cell.ratingLabel.text = movie.ratingText
            cell.movieImage?.af.setImage(withURL: movie.backdropURL)
            
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = selectedBackgroundView
            
            let favoriteMovie = fetchFavoriteMovie(with: movie.id, context: context)
            
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
            let selectedMovie = movies[indexPath.row]
            
            if let movieDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsController") as? MovieDetailsController {
                movieDetailsViewController.movieId = selectedMovie.id
                navigationController?.pushViewController(movieDetailsViewController, animated: true)
            }
        }

    }
        

