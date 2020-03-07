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
                    self.imagesCollectionView.sd_setImage(with: url, completed: .none)
                    //self.imagesCollectionView.sd_setImage(with: url, completed: .none)
               }
                self.spinner.stopAnimating()
                self.activityIndicator()
            })
            
   //     _ = imagesCollectionView.contentClippingRect
        
        
//           let frame = CGRect(x: 10, y: 10, width: self.frame.width - 20, height: 300)
//           self.imagesCollectionView.frame = frame
    }
}


//
//extension UIImageView {
//    var contentClippingRect: CGRect {
//        guard let image = image else { return bounds }
//        guard contentMode == .scaleAspectFit else { return bounds }
//        guard image.size.width > 0 && image.size.height > 0 else { return bounds }
//
//        let scale: CGFloat
//        if image.size.width > image.size.height {
//            scale = bounds.width / image.size.width
//        } else {
//            scale = bounds.height / image.size.height
//        }
//
//        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
//        let x = (bounds.width - size.width) / 2.0
//        let y = (bounds.height - size.height) / 2.0
//
//        return CGRect(x: x, y: y, width: size.width, height: size.height)
//    }
//}

