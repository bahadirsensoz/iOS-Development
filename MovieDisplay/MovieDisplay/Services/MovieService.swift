//
//  MovieService.swift
//  MovieDisplay
//
//  Created by Ali Bahadir Sensoz on 25.07.2023.
//

import Foundation


protocol MovieService{
    
    func fetchMovies(from endpoint: MovieListEndpoint,page: Int, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
        
    
    func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ())
        

    func searchMovie(query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
        
    
    
}

enum MovieListEndpoint: String, CaseIterable{
    case popular
    
    var description: String {
        switch self {
        case .popular: return "popular"
        }
    }
}

enum MovieError: Error, CustomNSError {
    
    case apiError
    case invalidEndpoint
    case noData
    case invalidResponse
    case serializationError
    
    
    var localizedDescription: String{
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
            
        }
    }
    
    var errorUserInfo: [String: Any]{
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}
