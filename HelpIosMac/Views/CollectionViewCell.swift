//
//  CollectionViewCell.swift
//  HelpIosMac
//
//  Created by Victor on 09/10/2019.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class CollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imagesCollectionView: UIImageView!
    
    func configCell(_ imagelist: String ){

        let folderPath = "images"
        
        let reference = Storage.storage().reference(withPath: "\(folderPath)/\(imagelist)")

        
            reference.downloadURL(completion: {(url, error)in
            print("Endereco da URL:\(String(describing: url))")
                if error != nil{
                    print("Gerou erro para mostrar a imagem\(error as Any)")
                }else{
              
                    self.imagesCollectionView.sd_setImage(with: url, completed: .none)
               }
            })
    }

    
}
