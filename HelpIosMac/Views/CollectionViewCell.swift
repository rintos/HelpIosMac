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
import NVActivityIndicatorView


class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imagesCollectionView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    func activityIndicator(){
          spinner?.hidesWhenStopped = true
      }
    
    func configCell(_ imagelist: String ){
        
        let folderPath = "images"
        
        let reference = Storage.storage().reference(withPath: "\(folderPath)/\(imagelist)")

            reference.downloadURL(completion: {(url, error)in
            print("Endereco da URL:\(String(describing: url))")
                if error != nil{
                    print("Gerou erro para mostrar a imagem\(error as Any)")
                   let erro = error.unsafelyUnwrapped.localizedDescription
                    print("---->>>\(erro)")
                    if erro == error.unsafelyUnwrapped.localizedDescription {
                        self.imagesCollectionView.image = UIImage(named: "Apple-icon-1" )
                    }

                }else{
                    
                    self.spinner.startAnimating()
                    self.imagesCollectionView.sd_setImage(with: url, placeholderImage: UIImage(named: "Apple-icon-1"), completed: .none)
                    //self.imagesCollectionView.sd_setImage(with: url, completed: .none)
               }
                self.spinner.stopAnimating()
                self.activityIndicator()
            })
    }
}
