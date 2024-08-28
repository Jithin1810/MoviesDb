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

    let movieUrl = "https://www.omdbapi.com/"
    let apiKey = "&apikey=3940df7"
    var delegate: MovieDetailsManagerDelegate?
    var selectedMovie : Movies
    var network : NetworkingClient
    init(delegate: MovieDetailsManagerDelegate? = nil, selectedMovie: Movies, network : NetworkingClient) {
        self.delegate = delegate
        self.selectedMovie = selectedMovie
        self.network = network
    }
    func featchMovie(){
        let urlString = "\(movieUrl)?t=\(selectedMovie.Title!)\(apiKey)"
        performRequest(urlString: urlString)
    }
    func performRequest(urlString: String){
        if let url = URL(string: urlString){
            
            network.request(url: url) { [weak self]data,error in
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
