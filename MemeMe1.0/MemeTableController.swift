//
//  SentMemesTableController.swift
//  MemeMe1.0
//

//  Created by Elisangela Pethke on 27.06.24.
//

import UIKit

class MemeTableController: UITableViewController{
    
    var meme: [CustomMeme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.meme
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadTableViewData()
    }
    
    
    private func reloadTableViewData() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meme.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as? MemeTableViewCell else {
            fatalError("Unable to dequeue SentMemesTableViewCell")
        }
        
        let meme = meme[indexPath.row]
        cell.configure(with: meme)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetailViewController(for: indexPath)
    }
    

    private func showDetailViewController(for indexPath: IndexPath) {
        guard let detailMemeController = storyboard?.instantiateViewController(withIdentifier: "MemesDetailController") as? MemeDetailController else {
            fatalError("Unable to instantiate MemesDetailController")
        }
        
        detailMemeController.meme = meme[indexPath.row]
        navigationController?.pushViewController(detailMemeController, animated: true)
    }
    
    @IBAction func memeSegue(_ sender: Any) {
        presentMemeController()
    }
    
    private func presentMemeController() {
        guard let memeController = storyboard?.instantiateViewController(withIdentifier: "MemeGeneratorViewController") as? MemeGeneratorViewController else {
            fatalError("Unable to instantiate MemeController")
        }
        
        memeController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(memeController, animated: true, completion: nil)
    }
    
}

extension MemeTableViewCell{
    func configure(with meme: CustomMeme) {
        topLabel.text = meme.upperText
        bottomLabel.text = meme.lowerText
        myImage.image = meme.memeImage
    }
}

