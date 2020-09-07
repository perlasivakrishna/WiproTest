//
//  AlbumViewModel.swift
//  WiproTest
//
//  Created by siva krishna on 05/09/20.
//  Copyright © 2020 Siva Krishna. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class AlbumViewModel {
    private var dataService: AlbumDataService?
    init(_ dataService:AlbumDataService) {
        self.dataService = dataService
    }
    var didFinish: (() -> Void)?
    var didFailed: (() -> Void)?
    var albums: [Album]?
    var totalResults = 0
    var currentPage = 1
    
    func fetchAlbums(for text: String, fetchMore: Bool = false) {
        if fetchMore {
            if totalResults <= self.albums?.count ?? 0 {
                return
            }
        }
        self.dataService?.getAlbums(for: text, page: 1, { (response, error) in
            guard let json = response as? [String: Any], let results = json["results"] as? [String: Any], let albumMatches = results["albummatches"] as? [String: Any] else {
                return
            }
            
            if let totalCount = results["opensearch:totalResults"] as? String {
                self.totalResults = Int(totalCount) ?? 0
            }
            if let queryResults = results["opensearch:Query"] as? [String: Any], let pageString = queryResults["startPage"] as? String {
                self.currentPage = Int(pageString) ?? 1
            }
            let albums = Mapper<Album>().mapArray(JSONObject: albumMatches["album"])
            if fetchMore {
                self.albums?.append(contentsOf: albums ?? [])
            } else {
                self.albums = albums
            }
            self.didFinish?()
        })
    }
}

struct AlbumDataService {
    typealias completionHandler = (Any?, Error?) -> Void
    private let albumsUrl = "http://ws.audioscrobbler.com/2.0/?method=album.search"

    func getAlbums(for text: String, page: Int, _ completionHandler: @escaping completionHandler) {
        let params = ["album": text,
                      "page": page,
                      "api_key": AppConstants.ApiKeys.lastFm,
                      "format": "json"] as [String : Any]
        
        AF.request(albumsUrl, method: .post, parameters: params, encoding: URLEncoding.queryString).responseJSON { response in
            switch response.result {
            case .success(let response):
                completionHandler(response, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
}
