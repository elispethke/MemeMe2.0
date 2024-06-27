//
//  SentMemesCollectionViewCell.swift
//  MemeMe1.0
//
//  Created by Elisangela Pethke on 27.06.24.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var bottomText: UILabel!

    func configure(with meme: CustomMeme) {
            memeImage.image = meme.memeImage
            topText.text = meme.upperText
            bottomText.text = meme.lowerText
        }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        memeImage.layer.cornerRadius = 8
    }
}
