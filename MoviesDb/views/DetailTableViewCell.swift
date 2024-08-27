//
//  DetailTableViewCell.swift
//  MoviesDb
//
//  Created by JiTHiN on 27/08/24.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var directorStack: UIStackView!
    @IBOutlet weak var actorsStack: UIStackView!
    @IBOutlet weak var plotStack: UIStackView!
    @IBOutlet weak var GenreStack: UIStackView!
    @IBOutlet weak var imdbStack: UIStackView!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ movie : Movies){
        movieNameLabel.text = movie.Title
        yearLabel.text = movie.Year
        if let url = URL(string: movie.Poster!) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.posterView.image = UIImage(data: data)
                    }
                }
            }
        }
        if let director = movie.Director{
            directorLabel.text = director
        }else{
            directorStack.isHidden = true
        }
        if let actor = movie.Actors{
            actorLabel.text = actor
        }else{
            actorLabel.isHidden = true
        }
        if let plot = movie.Plot {
            plotLabel.text = plot
        }else{
            plotStack.isHidden = true
        }
        if let genre = movie.Genre{
            genreLabel.text = genre
        }else{
            GenreStack.isHidden = true
        }
        if let imdb = movie.imdbRating{
            ratingsLabel.text = imdb
        }else{
            imdbStack.isHidden = true
        }
    }

}
