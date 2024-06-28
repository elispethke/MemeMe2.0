//
//  MemesDetailController.swift
//  MemeMe1.0
//
//  Created by Elisangela Pethke on 27.06.24.

//

import Foundation
import UIKit


class MemeDetailController: UIViewController {
    
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomText: UILabel!
    
    var meme: CustomMeme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.bottomText.text = meme.lowerText
        self.memeImageView.image = meme.memeImage
        self.topLabel.text = meme.upperText
        
        
    }
}
