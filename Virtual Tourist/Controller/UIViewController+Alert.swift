//
//  UIViewController+Alert.swift
//  Virtual Tourist
//
//  Created by Javon Davis on 27/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
