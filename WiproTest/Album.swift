//
//  Album.swift
//  WiproTest
//
//  Created by siva krishna on 05/09/20.
//  Copyright © 2020 Siva Krishna. All rights reserved.
//

import UIKit
import ObjectMapper

enum ImageSize: String {
    case small, medium, large, extralarge
}

struct Album {
    var name: String!
    var artist: String!
    var url: String!
    var images = [AlbumImage]()
    
    func imageOf(size: ImageSize) -> String? {
        let image =  images.first { $0.size == size.rawValue }
        return image?.url
    }
}

extension Album: Mappable {
    init?(map: Map) {
        
    }

    mutating func mapping(map: Map) {
        name <- map["name"]
        artist <- map["artist"]
        url <- map["url"]
        images <- map["image"]
    }
}

struct AlbumImage {
    var url: String!
    var size: String!
}

extension AlbumImage: Mappable {
    init?(map: Map) {
        
    }

    mutating func mapping(map: Map) {
        url <- map["#text"]
        size <- map["size"]
    }
}
