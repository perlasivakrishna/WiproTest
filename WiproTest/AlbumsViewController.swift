//
//  AlbumsViewController.swift
//  WiproTest
//
//  Created by siva krishna on 05/09/20.
//  Copyright © 2020 Siva Krishna. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    let viewModel = AlbumViewModel(AlbumDataService())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "AlbumTableViewCell", bundle: nil), forCellReuseIdentifier: AlbumTableViewCell.reuseIdentifier)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Albums"
        navigationItem.searchController = searchController
        definesPresentationContext = true
//        searchController.searchBar.delegate = self
    }
    
    func setupViewModel() {
        viewModel.didFinish = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func showAlbumDetails(album: Album) {
        let detailsVc = self.storyboard?.instantiateViewController(identifier: "AlbumDetailsViewController") as!  AlbumDetailsViewController
        detailsVc.album = album
        self.navigationController?.pushViewController(detailsVc, animated: true)
    }
}

extension AlbumsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.albums?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.reuseIdentifier, for: indexPath) as? AlbumTableViewCell else { return UITableViewCell() }
        let album = viewModel.albums?[indexPath.row]
        cell.album = album
        cell.configureCell()
        return cell
    }
}

extension AlbumsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let album = viewModel.albums?[indexPath.row] {
            showAlbumDetails(album: album)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            viewModel.fetchAlbums(for: searchController.searchBar.text!, fetchMore: true)
        }
    }
}

extension AlbumsViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    viewModel.fetchAlbums(for: searchBar.text!)
  }
}
