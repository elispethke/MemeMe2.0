//
//  SentMemesTableViewCell.swift
//  MemeMe1.0
//
//  Created by Elisangela Pethke on 27.06.24.
//

import Foundation
import UIKit

class MemeTableViewCell: UITableViewCell {
    
       @IBOutlet weak var myImage: UIImageView!
       @IBOutlet weak var topLabel: UILabel!
       @IBOutlet weak var bottomLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
       
        myImage.layer.cornerRadius = 8
    }

}
