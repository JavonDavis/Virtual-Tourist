//
//  Types.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 29/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation

typealias SessionResponse = (Data?, Error?) -> Void // Response from the execution of a SessionTask without the URLResponse?, URL Response parsed in Client
typealias FlickrPhotoResponse = ([Photo]) -> Void // Response sent to completion when photos are loaded
