//
//  Database.swift
//  MovieDisplay
//
//  Created by Ali Bahadir Sensoz on 9.08.2023.
//

import Foundation
import CoreData
import UIKit



final class Database {
    static let shared = Database()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieDisplay")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        })
        return container
    }()
    
    func saveFavoriteMovie(_ favoriteMovie: FavoriteMovie, image: UIImage) {
        let context = Database.shared.persistentContainer.viewContext
        
        let favorite = FavoriteMovie(context: context)
        favorite.id = favoriteMovie.id
        favorite.title = favoriteMovie.title
        favorite.releaseDate = favoriteMovie.releaseDate
        favorite.ratingText = favoriteMovie.ratingText
        
        saveImage(image, for: favorite)
        
        do {
            try context.save()
        } catch {
            print("Failed to save favorite movie: \(error.localizedDescription)")
        }
    }
    
    func removeFavoriteMovie(_ favoriteMovie: FavoriteMovie) {
        let context = Database.shared.persistentContainer.viewContext
        
        do {
            context.delete(favoriteMovie)
            try context.save()
        } catch {
            print("Failed to remove favorite movie: \(error.localizedDescription)")
        }
    }
    
    func isFavorite(_ favoriteMovie: FavoriteMovie) -> Bool {
        let context = Database.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", favoriteMovie.id)

        do {
            let favorites = try context.fetch(fetchRequest)
            return !favorites.isEmpty
        } catch {
            print("Error checking if movie is a favorite: \(error.localizedDescription)")
            return false
        }
    }
    
    func fetchAllFavoriteMovies() -> [FavoriteMovie] {
        let context = Database.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()

        do {
            let favoriteMovies = try context.fetch(fetchRequest)
            return favoriteMovies
        } catch {
            print("Error fetching favorite movies: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveImage(_ image: UIImage, for favoriteMovie: FavoriteMovie) {
        let context = Database.shared.persistentContainer.viewContext
        favoriteMovie.image = image.jpegData(compressionQuality: 0.8)
        
        do {
            try context.save()
        } catch {
            print("Failed to save image: \(error.localizedDescription)")
        }
    }
}
