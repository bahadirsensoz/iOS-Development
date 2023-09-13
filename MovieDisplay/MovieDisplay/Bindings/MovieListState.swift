import Foundation

class MovieListState: ObservableObject {
    
    @Published var movies: [Movie]?
    @Published var isLoading = false
    @Published var error: NSError?
    
    private let movieService: MovieService
    
    private var currentPage = 1
    private var isFetchingData = false
    private var isEndOfData = false
    
    init(movieService: MovieService = MovieStore.shared){
        self.movieService = movieService
    }
    
    func loadMovies(with endpoint: MovieListEndpoint) {
        guard !isFetchingData && !isEndOfData else {
            return
        }
        isFetchingData = true
        isLoading = true
        error = nil

        movieService.fetchMovies(from: endpoint, page: currentPage) { [weak self] (result) in
            guard let self = self else { return }
            self.isFetchingData = false
            self.isLoading = false

            switch result {
            case .success(let response):
                if !response.results.isEmpty {
                    if self.movies == nil {
                        self.movies = response.results
                    } else {
                        self.movies?.append(contentsOf: response.results)
                    }
                    self.currentPage += 1
                } else {
                    self.isEndOfData = true
                }
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
}
