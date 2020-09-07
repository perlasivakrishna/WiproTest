//
//  AlbumDetailsViewController.swift
//  WiproTest
//
//  Created by siva krishna on 06/09/20.
//  Copyright © 2020 Siva Krishna. All rights reserved.
//

import UIKit

class AlbumDetailsViewController: UIViewController {
    var album: Album!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        self.navigationItem.title = album.name
        detailsLabel.text = "Artist: \(album.artist ?? "Unknown")"
        if let imageUrl = album.imageOf(size: .extralarge), let url = URL(string: imageUrl) {
            albumImageView.af.setImage(withURL: url)
        }
    }
}
