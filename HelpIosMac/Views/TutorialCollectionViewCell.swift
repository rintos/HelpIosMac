//
//  TutorialCollectionViewCell.swift
//  HelpIosMac
//
//  Created by Victor on 11/09/2019.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage


class TutorialCollectionViewCell: UICollectionViewCell {
 
    
    @IBOutlet weak var imagemTutorial:UIImageView!
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var descricaoTextView: UITextView!

        
    func configCollectionCell(_ tutorial: Tutorial){
        
        tituloLabel.text = tutorial.name
        descricaoTextView.text = tutorial.details
        imagemTutorial.layer.borderWidth = 0.5

        guard let nameImage = tutorial.imagesUrl.first else { return }


        let folderPath = "images"
        
        let reference = Storage.storage().reference(withPath: "\(folderPath)/\(nameImage)")
        
            reference.downloadURL(completion: {(url, error)in
            print("Endereco da URL:\(String(describing: url))")
                if error != nil{
                    print("Gerou erro para mostrar a imagem\(error as Any)")
                }else{
              
                    self.imagemTutorial.sd_setImage(with: url, completed: .none)
              
               }
            })
    
    }
    
    
}
