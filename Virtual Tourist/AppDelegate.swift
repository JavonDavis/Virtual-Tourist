//
//  AppDelegate.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 26/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let coreDataStack = CoreDataStack(modelName: "TouristModel")! // i.e. NSManagedObjectModel, NSManagedObjectContext, NSPersistentStore, NSPersistentStoreCoordinator
    
    func loadImagesInBackground(photoAlbum: PhotoAlbum) { // Thought it best to put it here
        let pin = photoAlbum.pin
        
        let latitude = pin!.latitude
        let longitude = pin!.longitude
        
        let flickrClient = FlickrClient.shared
        
        flickrClient.getPhotoURLs(latitude: latitude, longitude: longitude, completion: { urlObjects, error in
            print("Back from Flickr")
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            print(urlObjects!.count)
            
            let numberOfPhotos = min(21, urlObjects!.count)
            photoAlbum.total = Int16(numberOfPhotos)
            
            self.coreDataStack.performBackgroundBatchOperation({ workerContext in
                print("Loading images in Background")
                
                let urlObjectsToLoad = urlObjects!.choose(Int(photoAlbum.total))
                
                for urlObject in urlObjectsToLoad {
                    let url = urlObject[Constants.Flickr.ResponseKeys.mediumURL]
                    let photoId = urlObject["id"]
                    
                    print(url!)
                    
                    let imageURL = URL(string: url as! String)
                    if let imageData = NSData(contentsOf: imageURL!) {
                        let photo = Photo(photoId: photoId as! String, imageData: imageData, context: workerContext)
                        photo.addToPhotoAlbums(photoAlbum)
                    }
                    
                }
            })
        })
        
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        coreDataStack.autoSave(60)
//        do {
//            try coreDataStack.dropAllData()
//        } catch {
//            print("erreor dropping all data")
//            print(error.localizedDescription)
//        }
//        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        coreDataStack.save()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        coreDataStack.save()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("Hello World :)")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("Goodbye Cruel World... :(")
    }


}

