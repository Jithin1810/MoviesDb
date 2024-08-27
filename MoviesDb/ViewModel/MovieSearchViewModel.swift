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
    var moviesArray = [Movies]()
    
    var favouriteService = FavoritesService()
    
    func featchMovie(movieName: String){
        let urlString = "\(movieUrl)?s=\(movieName)\(apiKey)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { [ weak self] data, url, error in
                if error != nil {
                    self?.delegate?.didFailWithError(error!)
                }
                if let safeData = data{
                    if let movie = self?.parseJson(safeData){
                        self?.moviesArray = movie
                        self?.delegate?.didUpdateMovie()
                    }
                }
            }
            task.resume()
        }
    }
    
    //parsing the data
    func parseJson(_ movieData : Data) -> [Movies]?{
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(SearchMoviesResponseModel.self, from: movieData)
            return decodeData.Search
        }catch{
            //self.delegate?.didFailWithError(error)
            return []
        }
    }
    func movieCount() -> Int{
        return moviesArray.count
    }
    func modelAt(_ index : Int) -> Movies {
        return moviesArray[index]
    }
    func clearAllResult(){
        moviesArray.removeAll()
    }
    
    
    func toggleFavourite(for imdbId : String ){
        if isFavourite(imdbId: imdbId){
            favouriteService.removeFavorite(imdbID: imdbId)
        }else{
            let movie = moviesArray.first { $0.imdbID == imdbId }
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
