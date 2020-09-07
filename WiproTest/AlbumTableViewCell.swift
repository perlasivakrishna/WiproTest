//
//  AlbumTableViewCell.swift
//  WiproTest
//
//  Created by siva krishna on 05/09/20.
//  Copyright © 2020 Siva Krishna. All rights reserved.
//

import UIKit
import AlamofireImage

class AlbumTableViewCell: UITableViewCell {
    static var reuseIdentifier = "AlbumTableViewCell"
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!

    var album: Album?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        artistLabel.text = ""
        albumImageView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell() {
        nameLabel.text = album?.name
        artistLabel.text = album?.artist
        if let imageUrl = album?.imageOf(size: .small), let url = URL(string: imageUrl) {
            albumImageView.af.setImage(withURL: url)
        }
    }
}

extension AlbumsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}
