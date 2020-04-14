//
//  ImageZoomViewController.swift
//  HelpIosMac
//
//  Created by Victor Soares de Almeida on 13/04/20.
//  Copyright © 2020 Rinver. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class ImageZoomViewController: UIViewController, UIScrollViewDelegate{

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageTutorial: UIImageView!
    
    var tutorial:Tutorial?
    var img = ""
    var pathImage:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configScroll()
        setupImage()

    }
    
    func configScroll() {
        scrollView.delegate = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageTutorial
    }
    
    func setupImage() {
        let folderPath = "images"
        
        let reference = Storage.storage().reference(withPath: "\(folderPath)/\(img)")

            reference.downloadURL(completion: {(url, error)in
            print("Endereco da URL:\(String(describing: url))")
                if error != nil{
                    print("Gerou erro para mostrar a imagem\(error as Any)")
                   let erro = error.unsafelyUnwrapped.localizedDescription
                    print("---->>>\(erro)")
                    if erro == error.unsafelyUnwrapped.localizedDescription {
                        self.imageTutorial.image = UIImage(named: "Apple-icon-1" )
                    }

                }else{
                    self.imageTutorial.sd_setImage(with: url, completed: .none)
                    //self.imagesCollectionView.sd_setImage(with: url, completed: .none)
               }
            })

    }

}
