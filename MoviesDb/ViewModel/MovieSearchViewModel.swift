//
//  MovieSearchViewModel.swift
//  MoviesDb
//
//  Created by JiTHiN on 27/08/24.
//
import UIKit
import Foundation
protocol MovieSearchManagerDelegate {
    func didUpdateMovie()
    func didFailWithError(_ error : Error)
}



class MovieSearchViewModel {
    let movieUrl = "https://www.omdbapi.com/"
    let apiKey = "&apikey=3940df7"
    
    var delegate: MovieSearchManagerDelegate?
    //var moviesArray = [Movies]()
    
    let sectionstitles = ["Search Results","Favorite Movies"]
    var favoriteMovies = [Movies]()
    var searchResults = [Movies]()
    
    var favouriteService = FavoritesService()
    var network: NetworkingClient!
    
    func featchMovie(movieName: String){
        let urlString = "\(movieUrl)?s=\(movieName)\(apiKey)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String){
        if let url = URL(string: urlString){
            network.request(url: url) {[weak self] data, error in
                if let error = error {
                    self?.delegate?.didFailWithError(error)
                    return
                }
                
                if let safeData = data {
                    if let movie = self?.parseJson(safeData){
                        self?.searchResults = movie
                        self?.delegate?.didUpdateMovie()
                    }
                }
            }
        }
    }
    
    //parsing the data
    func parseJson(_ movieData : Data) -> [Movies]?{
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(SearchMoviesResponseModel.self, from: movieData)
            return decodeData.Search
        }catch{
            return []
        }
    }
    
    func movieCount() -> Int{
        return searchResults.count
    }
    func modelAt(_ index : IndexPath) -> Movies {
        switch index.section {
               case 0:
                   return searchResults[index.row]
               case 1:
                   return favoriteMovies[index.row]
               default:
                   fatalError("Unexpected section")
               }
    }
    func clearAllResult(){
        searchResults.removeAll()
    }
    
    //for displaying favourite movies
    func loadFavoriteMovies() {
        let favoriteMovies = favouriteService.loadFavorites()
        self.favoriteMovies = favoriteMovies
        delegate?.didUpdateMovie()
    }
    
    func toggleFavourite(for imdbId : String ){
        if isFavourite(imdbId: imdbId){
            favouriteService.removeFavorite(imdbID: imdbId)
        }else{
            let movie = searchResults.first { $0.imdbID == imdbId }
            if let movie = movie{
                favouriteService.saveFavorite(movie: movie)
            }
        }
    }
    func isFavourite(imdbId : String) -> Bool{
        let favorite = favouriteService.loadFavorites()
        return favorite.contains(where: { $0.imdbID == imdbId })
        
    }
}
