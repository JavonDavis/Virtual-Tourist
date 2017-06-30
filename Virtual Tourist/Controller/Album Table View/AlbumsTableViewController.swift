//
//  AlbumsTableViewController.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 29/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit
import CoreData

protocol PhotoAlbumDelegate {
    func setAlbum(album: PhotoAlbum?)
}

class AlbumsTableViewController: CoreDataTableViewController {
    
    var pin: Pin?
    var currentAlbum: PhotoAlbum?
    var photoAlbumDelegate: PhotoAlbumDelegate?

    // MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = nil

        // Set up the data using NSFetchedResultsController 
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let coreDataStack = appDelegate.coreDataStack
        let context = coreDataStack.context
        
        if let pin = pin {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PhotoAlbum.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
            
            let predicate = NSPredicate(format: "pin = %@", argumentArray: [pin])
            fetchRequest.predicate = predicate
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }
        
        self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK:- TableView Delegate functions
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumsTableViewCell", for: indexPath)

        let photoAlbum = fetchedResultsController?.object(at: indexPath) as! PhotoAlbum
        let photoCount = Int(photoAlbum.total)
        
        cell.textLabel?.text = photoAlbum.name
        cell.detailTextLabel?.text = "\(photoCount) photo\(photoCount == 1 ? "":"s")"
        
        return cell
    }
 

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func addAlbum() {
        let albumCount = fetchedResultsController!.fetchedObjects!.count
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let photoAlbum = PhotoAlbum(name: "Photo album \(albumCount)", context: appDelegate.coreDataStack.context)
        photoAlbum.pin = pin
        
        appDelegate.loadImagesInBackground(pin: pin!, photoAlbumId: photoAlbum.objectID)
    }
    
    // MARK:- TableView Editing
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
        
        if let context = fetchedResultsController?.managedObjectContext, let photoAlbum = fetchedResultsController?.object(at: indexPath) as? PhotoAlbum, editingStyle == .delete {
            let albumCount = fetchedResultsController!.fetchedObjects!.count
            
            guard albumCount > 1 else {
                showAlert(title: "Need at least 1 album", message: "Sorry you need to have at least one Photo Album, either delete the pin or create a new Photo Album before deleting this one")
                return 
            }
            
            if let currentAlbum = currentAlbum {
                if photoAlbum.objectID == currentAlbum.objectID { // The album being deleted was the one currently being viewed on the pin
                    
                    photoAlbumDelegate?.setAlbum(album: nil)  // Nullify that reference
                    
                }
            }
            context.delete(photoAlbum)
        }
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photoAlbum = fetchedResultsController?.object(at: indexPath) as! PhotoAlbum
        
        photoAlbumDelegate?.setAlbum(album: photoAlbum) // Pass the album to the parent
        tableView.deselectRow(at: indexPath, animated: true) // Deselect the row
        
        self.navigationController?.popViewController(animated: true) // Pop the navigation stack
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        if editing { // Add a button for creating a new album
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAlbum))
            self.navigationItem.leftBarButtonItem = addButton
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
}
