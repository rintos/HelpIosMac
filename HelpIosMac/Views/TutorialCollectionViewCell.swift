//
//  TutorialCollectionViewCell.swift
//  HelpIosMac
//
//  Created by Victor on 11/09/2019.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit
import Firebase

class TutorialCollectionViewCell: UICollectionViewCell {
 
    
    @IBOutlet weak var imagemTutorial:UIImageView!
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var descricaoTextView: UITextView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var statusInternetLabel: UILabel!
    
    func activitySpinner(){
        spinner.hidesWhenStopped = true
    }
    
    
    
    func configCollectionCell(_ tutorial: Tutorial){
        
        FireBase.verifyInternet({ (stat) in
            self.statusInternetLabel.isHidden = stat

        })
        
        tituloLabel.text = tutorial.name
        descricaoTextView.text = Tutorial.organizaTexto(tutorial.details)
       // descricaoTextView.text = tutorial.details
        imagemTutorial.layer.borderWidth = 2
        imagemTutorial.layer.backgroundColor = UIColor.black.cgColor
        imagemTutorial.layer.cornerRadius = 6.0
        imagemTutorial.layer.masksToBounds = true
        
        tituloLabel.layer.cornerRadius = 6.0
        tituloLabel.layer.masksToBounds = true
        descricaoTextView.layer.cornerRadius = 6.0
        descricaoTextView.layer.masksToBounds = true
        

        guard let nameImage = tutorial.imagesUrl.first else { return }


        let folderPath = "images"
        
        let reference = Storage.storage().reference(withPath: "\(folderPath)/\(nameImage)")
        
            reference.downloadURL(completion: {(url, error)in
            print("Endereco da URL:\(String(describing: url))")
                if error != nil{
                    print("--------> Gerou erro para mostrar a imagem\(error as Any)")
                    let erro = error.unsafelyUnwrapped.localizedDescription
                     print("---->>>\(erro)")
                     if erro == error.unsafelyUnwrapped.localizedDescription {
                         self.imagemTutorial.image = UIImage(named: "Apple-icon-1" )
                     }
                }else{
                    self.spinner.startAnimating()
                    self.imagemTutorial.sd_setImage(with: url , completed: .none)
                    
                    //self.imagemTutorial.sd_setImage(with: url, completed: .none)
               }
                self.spinner.stopAnimating()
                self.activitySpinner()

            })
    

    }
    
    
}


extension String {
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}
