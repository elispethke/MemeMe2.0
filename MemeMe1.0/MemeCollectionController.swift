//
//  SentMemesCollectionController.swift
//  MemeMe1.0
//
//  Created by Elisangela Pethke on 27.06.24.
//


import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    var meme: [CustomMeme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.meme
    }
    
    let space: CGFloat = 1.0
    var dimension: CGFloat = 0.0
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dimension = (view.frame.size.width - (2 * space)) / 1.5
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumInteritemSpacing = space
            flowLayout.minimumLineSpacing = space
            flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        } else {
            print("Error: Unable to configure flow layout.")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meme.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? MemeCollectionViewCell else {
            fatalError("Unable to dequeue SentMemesCollectionViewCell")
        }
        
        let meme = self.meme[indexPath.row]
        cell.configure(with: meme)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailMemeController = storyboard?.instantiateViewController(withIdentifier: "MemesDetailController") as? MemeDetailController else {
            fatalError("Unable to instantiate MemesDetailController")
        }
        
        detailMemeController.meme = meme[indexPath.row]
        navigationController?.pushViewController(detailMemeController, animated: true)
    }
    
    @IBAction func memeSegue(_ sender: Any) {
        
        let controller = storyboard?.instantiateViewController(identifier: "MemeGeneratorViewController") as! MemeGeneratorViewController
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
}



