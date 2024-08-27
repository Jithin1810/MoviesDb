//
//  MovieTableViewController.swift
//  MoviesDb
//
//  Created by JiTHiN on 23/08/24.
//

import UIKit

class MovieTableViewController: UITableViewController, UISearchBarDelegate,MovieSearchManagerDelegate {
     
    @IBOutlet weak var searchBar: UISearchBar!
    var movieViewModel: MovieSearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieViewModel = MovieSearchViewModel()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        movieViewModel.delegate = self
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieViewModel.movieCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! MoviesTableViewCell
        let movie = movieViewModel.modelAt(indexPath.row)
        cell.configure(movie)
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movieViewModel.modelAt(indexPath.row)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                guard let detailsVc = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
                    return
                }
        detailsVc.movieDetailModel = MovieDetailsViewModel(delegate: detailsVc, selectedMovie: selectedMovie)
                self.navigationController?.pushViewController(detailsVc, animated: true)
    }
    


     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation

    //MARK: - Search Box
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        starSearch()
    }
    
    
    func starSearch(){
        guard let title = searchBar.text else{
            return
        }
        movieViewModel.featchMovie(movieName: title)
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            movieViewModel.moviesArray.removeAll()
            tableView.reloadData()
            return
        }
    }
    
    
    //MARK: - Update Movie
    func didUpdateMovie() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(_ error: any Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}
