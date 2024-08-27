//
//  MovieDetailsViewModel.swift
//  MoviesDb
//
//  Created by JiTHiN on 27/08/24.
//

import Foundation

protocol MovieDetailsManagerDelegate{
    func didUpdateMovieDetails()
    func didFailWithError(_ error : Error)
}

class MovieDetailsViewModel{
    init(delegate: MovieDetailsManagerDelegate? = nil, selectedMovie: Movies!) {
        self.delegate = delegate
        self.selectedMovie = selectedMovie
    }
    let movieUrl = "https://www.omdbapi.com/"
    let apiKey = "&apikey=3940df7"
    
    var delegate: MovieDetailsManagerDelegate?
    var selectedMovie : Movies!
    
    func featchMovie(){
        let urlString = "\(movieUrl)?t=\(selectedMovie.Title!)\(apiKey)"
        print(urlString)
        performRequest(urlString: urlString)
    }
    func performRequest(urlString: String){
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { [weak self]data, url, error in
                if error != nil {
                    self?.delegate?.didFailWithError(error!)
                }
                if let safeData = data{
                    if let movie = self?.parseJson(safeData){
                        self?.selectedMovie = movie
                        self?.delegate?.didUpdateMovieDetails()
                    }
                }
            }
            task.resume()
        }
    }
    func parseJson(_ movieData : Data) -> Movies?{
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(Movies.self, from: movieData)
            return decodeData
        }catch{
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
    func movieCount() -> Int{
        return 1
    }
    func modelAt(_ index : Int) -> Movies {
        return selectedMovie
    }
}
