//
//  detailViewController.swift
//  MoviesDb
//
//  Created by JiTHiN on 23/08/24.
//

import UIKit

class DetailViewController: UIViewController{
    @IBOutlet weak var detailTableView: UITableView!
    var movieDetailModel : MovieDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieDetailModel.featchMovie()
        detailTableView.delegate = self
        detailTableView.dataSource = self
        didUpdateMovieDetails()
    }
}
extension DetailViewController : MovieDetailsManagerDelegate{
    func didUpdateMovieDetails() {
        DispatchQueue.main.async {
            self.detailTableView.reloadData()
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
extension DetailViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieDetailModel.movieCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableView", for: indexPath) as! DetailTableViewCell
        let movie = movieDetailModel.modelAt(indexPath.row)
        cell.configure(movieDetailModel.selectedMovie)
        cell.selectionStyle = .none
        return cell
    }
    
     
}
extension DetailViewController : UITableViewDelegate{
}
