//
//  SentMemesFullImageController.swift
//  MemeMe1.0
//
//  Created by Doyinsola Osanyintolu on 4/6/20.
//  Copyright © 2020 DoyinOsanyintolu. All rights reserved.
//

import Foundation
import UIKit

class SentMemesFullImageViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!
    
    var memes: [Meme] {
              let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    return appDelegate.memes
      }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
}
