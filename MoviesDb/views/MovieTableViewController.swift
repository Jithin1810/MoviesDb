//
//  MovieTableViewController.swift
//  MoviesDb
//
//  Created by JiTHiN on 23/08/24.
//

import UIKit

class MovieTableViewController: UITableViewController, UISearchBarDelegate,MovieSearchManagerDelegate,CellDelegate {
     
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
        let isFavourite = movieViewModel.isFavourite(imdbId: movie.imdbID!)
        cell.configure(movie,indexPath,isFavourite, delegate: self)
        
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
    
    //MARK: - Search Box
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        starSearch()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
          if searchText.isEmpty {
              // Clear the table view data if the search text is empty
              movieViewModel.clearAllResult()
              tableView.reloadData()
          } 
        // for lessthan 3 chanarcter api will return nill.
        else if searchText.count > 2{
              // Update the table view data based on the search text
              movieViewModel.featchMovie(movieName: searchText)
          }
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
    
    
    //MARK: - Favourite
    
    func toggleFavourite(_ indexPath : IndexPath) {
        let movie = movieViewModel.modelAt(indexPath.row)
        self.movieViewModel.toggleFavourite(for: movie.imdbID!)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
