//
//  favouriteService.swift
//  MoviesDb
//
//  Created by JiTHiN on 27/08/24.
//

import Foundation

class FavoritesService {
    
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "favoriteMovies"
    
    // Save a favorite movie
    func saveFavorite(movie: Movies) {
        var favorites = loadFavorites()
        
        // Check if the movie is already in favorites to avoid duplicates
        if !favorites.contains(where: { $0.imdbID == movie.imdbID }) {
            favorites.append(movie)
            if let encoded = try? JSONEncoder().encode(favorites) {
                userDefaults.set(encoded, forKey: favoritesKey)
            }
        }
    }
    
    // Remove a favorite movie by imdbID
    func removeFavorite(imdbID: String) {
        var favorites = loadFavorites()
        favorites.removeAll { $0.imdbID == imdbID }
        if let encoded = try? JSONEncoder().encode(favorites) {
            userDefaults.set(encoded, forKey: favoritesKey)
        }
    }
    
    // Load the list of favorite movies
    func loadFavorites() -> [Movies] {
        if let data = userDefaults.data(forKey: favoritesKey),
           let favorites = try? JSONDecoder().decode([Movies].self, from: data) {
            return favorites
        }
        return []
    }
    
    // Check if a movie is a favorite
    func isFavorite(imdbID: String) -> Bool {
        let favorites = loadFavorites()
        return favorites.contains(where: { $0.imdbID == imdbID })
    }
}
