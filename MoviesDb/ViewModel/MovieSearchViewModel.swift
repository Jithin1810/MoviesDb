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
    func parseJson(_ movieData : Data) -> [Movies]?{
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(SearchMoviesResponseModel.self, from: movieData)
            return decodeData.Search
        }catch{
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
    func movieCount() -> Int{
        return moviesArray.count
    }
    func modelAt(_ index : Int) -> Movies {
        return moviesArray[index]
    }
}
