//
//  moviesTableViewCell.swift
//  MoviesDb
//
//  Created by JiTHiN on 24/08/24.
//

import UIKit
protocol CellDelegate : AnyObject{
    func toggleFavourite(_ indexPath : IndexPath)
}
class MoviesTableViewCell: UITableViewCell{
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    private weak var delegate : CellDelegate?
    private var indexPath : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ movie: Movies,_ indexPath: IndexPath,_ isFavourite : Bool, delegate: CellDelegate?) {
        self.indexPath = indexPath
        self.delegate = delegate
        movieNameLabel.text = movie.Title
        yearLabel.text = movie.Year
        favouriteButton.isSelected = isFavourite
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
    @IBAction func favouriteButtonPressed(_ sender: Any) {
        delegate?.toggleFavourite(indexPath!)
    }
    
}
