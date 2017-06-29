//
//  Constants.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 28/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation

struct Constants {
    struct Flickr {
        static let endpoint = "https://api.flickr.com/services/rest/"
        static let apiKey = "960d801bed7cddf495ddd40bd8ec3c55"
        static let secret = "52285446c139e243"
        
        struct RequestParameters {
            static let apiKey = "api_key"
            static let extras = "extras"
            static let format = "format"
            static let perPage = "per_page"
            static let latitude = "lat"
            static let longitude = "lon"
            static let method = "method"
            static let noJsonCallback = "nojsoncallback"
        }
        
        struct RequestParameterValues {
            static let extras = "url_m"
            static let format = "json"
            static let perPage = 100
            static let method = "flickr.photos.search"
            static let noJsonCallback = 1
        }
        struct ResponseKeys {
            static let mediumURL = "url_m"
            static let status = "stat"
            static let photosArray = "photo"
            static let photos = "photos"
            static let total = "total"
        }
    }
}
