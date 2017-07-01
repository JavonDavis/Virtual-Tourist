//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 29/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FlickrClient {
    
    static let shared: FlickrClient = FlickrClient()
    
    func getPhotoURLs(latitude: Double, longitude: Double, completion: @escaping FlickrPhotoURLsResponse) {
        let photosURL = Constants.Flickr.endpoint
        let parameters = [
            Constants.Flickr.RequestParameters.apiKey: Constants.Flickr.apiKey,
            Constants.Flickr.RequestParameters.method: Constants.Flickr.RequestParameterValues.method,
            Constants.Flickr.RequestParameters.perPage: Constants.Flickr.RequestParameterValues.perPage,
            Constants.Flickr.RequestParameters.format: Constants.Flickr.RequestParameterValues.format,
            Constants.Flickr.RequestParameters.extras: Constants.Flickr.RequestParameterValues.extras,
            Constants.Flickr.RequestParameters.noJsonCallback: Constants.Flickr.RequestParameterValues.noJsonCallback,
            Constants.Flickr.RequestParameters.latitude: latitude,
            Constants.Flickr.RequestParameters.longitude: longitude
        ] as [String: AnyObject]
        
        performGetRequestOn(url: photosURL, with: parameters, completion: { data, err in
            
            func sendError(message: String) {
                let userInfo = [NSLocalizedDescriptionKey : message]
                completion(nil, NSError(domain: "StudentCreationFromJSON", code: 1, userInfo: userInfo))
            }
            
            if let err = err {
                print(err.localizedDescription)
                sendError(message: err.localizedDescription)
                return
            }
            do {
                let jsonDict = try self.JSONDeserialize(jsonData: data!)
                
                let status = jsonDict[Constants.Flickr.ResponseKeys.status] as! String
                
                if status == "ok" {
                    let photosDict = jsonDict[Constants.Flickr.ResponseKeys.photos] as! Dictionary<String, AnyObject>
                    print(photosDict)
                    
                    let totalString = photosDict[Constants.Flickr.ResponseKeys.total] as! String
                    let total = Int(totalString)!
                    if total > 0 {
                        print("Successfully loaded images from Flickr")
                        let photosArray = photosDict[Constants.Flickr.ResponseKeys.photosArray] as! [Dictionary<String, AnyObject>]
                        completion(photosArray.map { $0[Constants.Flickr.ResponseKeys.mediumURL] as! String }, nil) // Return a list of URLs
                        print(photosArray)
                    } else {
                        print("Emptyy Array from Flickr")
                        completion([], nil)
                    }
                } else {
                    print("Error Loading data Fro Flickr")
                    sendError(message: "Error loading data from Flickr")
                }
            } catch {
                print(error.localizedDescription)
                sendError(message: error.localizedDescription)
            }
        })
    }
    
    func loadImageURLs(pin: Pin, completion: @escaping FlickrPhotoURLsResponse) { // Thought it best to put it here
        let latitude = pin.latitude
        let longitude = pin.longitude
        
        let flickrClient = FlickrClient.shared
        
        flickrClient.getPhotoURLs(latitude: latitude, longitude: longitude, completion: completion)
        
        
//        flickrClient.getPhotoURLs(latitude: latitude, longitude: longitude, completion: { urlObjects, error in
//            print("Back from Flickr")
//            guard error == nil else {
//                print(error!.localizedDescription)
//                return
//            }
//            
//            print(urlObjects!.count)
//            
//            let numberOfPhotos = min(21, urlObjects!.count)
//            
//            let urlObjectsToLoad = urlObjects!.choose(Int(numberOfPhotos))
//            
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let coreDataStack = appDelegate.coreDataStack
//            
//            coreDataStack.performBackgroundBatchOperation({ workerContext in
//                
//                if let photoAlbum = workerContext.object(with: objectId) as? PhotoAlbum { // Get the photo Album using this same context
//                    photoAlbum.total = Int16(numberOfPhotos)
//                    for urlObject in urlObjectsToLoad {
//                        let url = urlObject[Constants.Flickr.ResponseKeys.mediumURL]
//                        
//                        print(url!)
//                        
//                        let imageURL = URL(string: url as! String)
//                        if let imageData = NSData(contentsOf: imageURL!) {
//                            let photo = Photo(imageData: imageData, context: workerContext)
//                            photo.photoAlbum = photoAlbum
//                        }
//                        
//                        
//                    }
//                }
//            })
//            
//        })

    }
    
    private func JSONDeserialize(jsonData: Data) throws -> Dictionary<String, AnyObject> { // For Parsing a JSONObject
        return try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! Dictionary<String, AnyObject>
    }
    
    // MARK:- Netowrk Request Functionss
    
    private func escapedParameters(_ parameters: [String:AnyObject]) -> String {
        
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                print(value)
                // make sure that it is a string value
                let stringValue = "\(value)"
                
                // escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                // append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
                
            }
            
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
    
    func performGetRequestOn(url urlString: String, with parameters: [String:AnyObject], completion: @escaping SessionResponse) {
        
        // Build the URL
        let urlParametersString = escapedParameters(parameters)
        let finalURLString = urlString + urlParametersString
        let request = NSMutableURLRequest(url: URL(string: finalURLString)!)
        
        // Set the method of the Request
        request.httpMethod = "Get"
        
        // Start the session Task
        let task = URLSession.shared.dataTask(with: (request as URLRequest) as URLRequest) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "taskForNetworkRequest", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(error!.localizedDescription)
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                /* GUARD: Did we get a successful 2XX response? */
                guard statusCode >= 200 && statusCode <= 299 else {
                    var message = "Please try again later"
                    
                    if statusCode >= 400 && statusCode <= 499 {
                        message = "Please check your API Key"
                    } else if statusCode >= 500 && statusCode <= 599 {
                        message = "There was an error with Flickr servers, Please try again later"
                    }
                    sendError(message)
                    return
                }
            }
            
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("Please try again later")
                return
            }
            
            completion(data, nil)
        }
        task.resume()
    }
}
