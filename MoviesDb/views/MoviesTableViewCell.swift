//
//  moviesTableViewCell.swift
//  MoviesDb
//
//  Created by JiTHiN on 24/08/24.
//

import UIKit

class MoviesTableViewCell: UITableViewCell{

    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ movie: Movies) {
        movieNameLabel.text = movie.Title
        yearLabel.text = movie.Year
        if let url = URL(string: movie.Poster!) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.posterImageView.image = UIImage(data: data)

                    }
                }
            }
        }
    }

}
