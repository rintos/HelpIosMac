//
//  DetalheFavoritoViewController.swift
//  HelpIosMac
//
//  Created by Victor on 13/09/2019.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit
import CoreData

class DetalheFavoritoViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var tituloLabel:UILabel!
    @IBOutlet weak var textoTextView:UITextView!
    @IBOutlet weak var editarTextView:UITextView!
    
    
    @IBOutlet weak var imagensTutorialCollectionView: UICollectionView!
    
    
    var tutorial:Tutorials?

    var contexo:NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    
    let listImage = TutorialDAO().returnListImages()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagensTutorialCollectionView.dataSource = self
        imagensTutorialCollectionView.reloadData()
        
        print(tutorial as Any)
        self.setupSubirCodigo()
        
    }
    
    func setupSubirCodigo(){
        
        
        
        let barButton =  UIBarButtonItem(title: "Update", style: UIBarButtonItem.Style.done, target: self, action: #selector(salvarTurialGravado))
        navigationItem.rightBarButtonItem = barButton
        
        if let tutorialFavorito = tutorial{
            self.tituloLabel.text = tutorialFavorito.name
            self.textoTextView.text = tutorialFavorito.textDetails
            self.editarTextView.text = tutorialFavorito.makeTutorial
        }

    }
    
    
   @objc func salvarTurialGravado(){
    
    if tutorial == nil {
        tutorial = Tutorials(context: contexo)
    }
        tutorial?.name = self.tituloLabel.text
        tutorial?.textDetails = self.textoTextView.text
        tutorial?.makeTutorial = self.editarTextView.text
    
    
    do {
        try contexo.save()
        navigationController?.popToRootViewController(animated: true)
    } catch {
        print(error.localizedDescription)
    }

    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "images", for: indexPath) as! DetalhesCollectionViewCell
        let pathImage = listImage[indexPath.row]
        
        cell.imagensTutorial.image = UIImage(named: pathImage)
        
        return cell
    }
    

}
