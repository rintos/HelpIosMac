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
    var linkVideo = ""
    var listImages = TutorialDAO().returnListImages()
    var tutorialDetail: Tutorial? // recebe o tutorial selecionado da viewConroller
        
    var tutorials:Tutorials?
    
    var detailVideo = DetailVideoViewController()
    
    var contexo:NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
      
        return appDelegate.persistentContainer.viewContext
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "video"){
            detailVideo = (segue.destination as? DetailVideoViewController)!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let barButton =  UIBarButtonItem(title: "Salvar", style: UIBarButtonItem.Style.done, target: self, action: #selector(saveTutorial))
        navigationItem.rightBarButtonItem = barButton
        
        
        imagesCollectionView.dataSource = self
        imagesCollectionView.reloadData()
        
        self.titleTextLabel.text = titleDetail
        self.descriptionTextView.text = descriptionDetail
       
        print("Myvideo111: \(linkVideo)")//verificando string
        
        if let pathArrayImage = tutorialDetail?.imagesUrl{
            print("Meu array HAAHAHA \(String(describing: pathArrayImage.first))")
        }
        
    }
    
    //action que envia string do video para proxima tela
    @IBAction func sendLinkVideo(_ sender: Any) {
        detailVideo.urlVideo = linkVideo
    }
    
    //funcao para compartilhar conteudos

    @IBAction func shareContent(_ sender: Any) {
        print("TestTando Botao ahahah")
        guard let imageList = tutorialDetail?.imagesUrl else {return}
        
        var imagem: UIImage?
        if let image = imageList.first{
            imagem = UIImage(named:image)
        }
    
        print("Quantidade de fotos compartilhada: \(String(describing: imagem))")
        
        let activityController = UIActivityViewController(activityItems: [imagem], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = {(nil, completed, _, error)
            in
            if completed{
                print("completou o Share")
            }else{
                print("cancelado o share Mano")
            }
        }
        
        present(activityController, animated: true){
            print("apresentado meu share")
        }
    }
    
    @objc func recuperaTutorial()->Tutorial?{
                
        if let titulo = titleTextLabel?.text{
            if let texto = descriptionTextView?.text{
                if let pathArrayImage = tutorialDetail?.imagesUrl {
                    let tutorial = Tutorial(name: titulo, details: texto, imagesUrl: pathArrayImage)
                    //  print("Sanvando os dados titulo: \(tutorial.name) texto: \(tutorial.details)")
                    return tutorial
                }
            }
        }
        return nil
    }
    
    @objc func saveTutorial(){
        
        if tutorials == nil{
            tutorials = Tutorials(context: contexo)
        }
        
        if let tutorialFavorito = recuperaTutorial(){
       //     print(tutorialFavorito.name)
                        
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "favorito") as! FavoritosTableViewController
          //  controller.conteudoTutorial = tutorialFavorito
            
            tutorials?.name = titleDetail
            tutorials?.textDetails = descriptionDetail
            tutorials?.imagesUrl = tutorialFavorito.imagesUrl as NSObject
            
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
        guard let imageList = tutorialDetail?.imagesUrl else {return 0}
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageHome", for: indexPath) as! CollectionViewCell
        guard let imageList = tutorialDetail?.imagesUrl else {return cell}
        
        let pathImage = imageList[indexPath.row]
        cell.imagesCollectionView.image = UIImage(named: pathImage)
        
        return cell
    }
    
    
    

}
