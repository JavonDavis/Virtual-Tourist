//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 29/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation

class FlickrClient {
    
    static let shared: FlickrClient = FlickrClient()
    
    func getPhotos(latitude: Double, longitude: Double) {
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
            if let err = err {
                print(err.localizedDescription)
                return
            }
            do {
                let jsonDict = try self.JSONDeserialize(jsonData: data!)
                print(jsonDict)
                
                let status = jsonDict[Constants.Flickr.ResponseKeys.status] as! String
                
                if status == "ok" {
                    let photosDict = jsonDict[Constants.Flickr.ResponseKeys.photos] as! Dictionary<String, AnyObject>
                    print(photosDict)
                    
                    let totalString = photosDict[Constants.Flickr.ResponseKeys.total] as! String
                    let total = Int(totalString)!
                    if total > 0 {
                        let photosArray = photosDict[Constants.Flickr.ResponseKeys.photosArray] as! [Dictionary<String, AnyObject>]
                        print(photosArray)
                    } else {
                        // Empty Array
                    }
                } else {
                    // Error from Flickr
                }
                print("OK")
            } catch {
                print(error.localizedDescription)
            }
        })
    }
    
    func JSONDeserialize(jsonData: Data) throws -> Dictionary<String, AnyObject> { // For Parsing a JSONObject
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
        print(finalURLString)
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
