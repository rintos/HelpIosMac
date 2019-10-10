//
//  DetailsViewController.swift
//  HelpIosMac
//
//  Created by Victor on 28/08/2019.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class DetailsViewController: UIViewController,UICollectionViewDataSource {


    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    
    //Variaveis que recebem dados da ViewController
    var titleDetail = ""
    var descriptionDetail = ""
    var listImages = TutorialDAO().returnListImages()
        
    var tutorials:Tutorials?
    
    var contexo:NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
      
        return appDelegate.persistentContainer.viewContext
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let barButton =  UIBarButtonItem(title: "Salvar", style: UIBarButtonItem.Style.done, target: self, action: #selector(saveTutorial))
        navigationItem.rightBarButtonItem = barButton
        
        imagesCollectionView.dataSource = self
        imagesCollectionView.reloadData()
        
        self.titleTextLabel.text = titleDetail
        self.descriptionTextView.text = descriptionDetail
        
    }
    
    
    @objc func recuperaTutorial()->Tutorial?{
        
        if let titulo = titleTextLabel?.text{
            if let texto = descriptionTextView?.text{
                let tutorial = Tutorial(name: titulo, details: texto)
                print("Sanvando os dados titulo: \(tutorial.name) texto: \(tutorial.details)")
                return tutorial
            }
        }
        return nil
    }
    
    @objc func saveTutorial(){
        
        if tutorials == nil{
            tutorials = Tutorials(context: contexo)
        }
        
        if let tutorialFavorito = recuperaTutorial(){
            print(tutorialFavorito.name)
                        
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "favorito") as! FavoritosTableViewController
          //  controller.conteudoTutorial = tutorialFavorito
            
            tutorials?.name = titleDetail
            tutorials?.textDetails = descriptionDetail
            
            do{
                try contexo.save()
                
                if let navigation = navigationController{
                    navigation.popViewController(animated: true)
                }

            }catch{
                print(error.localizedDescription)
            }

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageHome", for: indexPath) as! CollectionViewCell
        let imagePath = listImages[indexPath.row]
        
        cell.imagesCollectionView.image = UIImage(named:imagePath )
        
        
        return cell
    }
    
    
    

}
