//
//  ViewController.swift
//  CollectionViewWithJSON
//
//  Created by Swapnil Kadam on 26/05/20.
//  Copyright © 2020 Swapnil Kadam. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
struct Hero : Decodable{
    
    let localized_name:String
    let img:String
    
}

class ViewController: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet weak var collectionview: UICollectionView!
    
    
    var heros = [Hero]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://api.opendota.com/api/heroStats")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil
            {
                do {
                    self.heros = try JSONDecoder().decode([Hero].self, from: data!)
                    
                    
                }
                catch{
                    print("parse error")
                }
                DispatchQueue.main.async {
                    //print(self.heros.count)
                    self.collectionview.reloadData()
                }
            }
            
        }.resume()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heros.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customcell", for: indexPath) as! customCollectionViewCell
        
        cell.lbl_name.text = heros[indexPath.row].localized_name.capitalized
        
        
        
        let defaultlink = "https://api.opendota.com"
        let completelink = defaultlink + heros[indexPath.row].img
        
        //cell.imgview.downloaded(link: completelink)
        cell.imgview.downloaded(from: completelink)
       cell.imgview.layer.masksToBounds = true
        cell.imgview.layer.cornerRadius = cell.imgview.frame.height/2
        //self.mainImageView.layer.cornerRadius = CGRectGetWidth(self.mainImageView.frame)/4.0
         cell.imgview.contentMode = .scaleAspectFill
        return cell
        
        
        
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
    }
    
    

}

