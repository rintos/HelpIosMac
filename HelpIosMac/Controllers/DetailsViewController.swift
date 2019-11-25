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
    
    //MARK: - Variaveis
    //Variaveis que recebem dados da ViewController
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
        
        setupDadosView()
                
    }
    
    //MARK: - Metodos
    
    func setupDadosView(){
        guard let detalheTutorial = tutorialDetail else { return }
        self.titleTextLabel.text = detalheTutorial.name
        self.descriptionTextView.text = detalheTutorial.details
    }
    
    
    //retorna array de lista de imagens para compartilhar
    func extraiImagens() -> Array<UIImage>{
        
        var imagemArray:Array<UIImage> = []
        
        if let imagens = tutorialDetail?.imagesUrl{
            
            for img in imagens{
                imagemArray.append((UIImage(named: img))!)
            }
        }
        
        return imagemArray
    }
    
    //action que envia string do video para proxima tela
    @IBAction func sendLinkVideo(_ sender: Any) {
        guard let linkYoutube = tutorialDetail?.linkVideo else { return }
        detailVideo.urlVideo = linkYoutube
    }
    
    //funcao para compartilhar conteudos

    @IBAction func shareContent(_ sender: Any) {
                
        let imagensLista = extraiImagens()
        
        let activityController = UIActivityViewController(activityItems: imagensLista as [Any], applicationActivities: nil)
                        
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
    
    @IBAction func compartilharTextoLinkVideo(_ sender: Any){
        
        guard let conteudoTutorial = tutorialDetail else { return }
        let video = "https://www.youtube.com/watch?v=\(conteudoTutorial.linkVideo)"
        
        let activityController = UIActivityViewController(activityItems: [video as Any,conteudoTutorial.name as Any, conteudoTutorial.details as Any], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = {(nil, completed, _, error)
            in
            if completed{
                print("compartilhamento realizado com sucesso")
            }else{
                print("cancelado o compartilhamento")
            }
        }
        
        present(activityController, animated: true)
        print("Compartilhamento apresentado com sucesso")
        
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
        
        guard let detalheTutorial = tutorialDetail else { return }

        if tutorials == nil{
            tutorials = Tutorials(context: contexo)
        }
        
        if let tutorialFavorito = recuperaTutorial(){
            tutorials?.name = detalheTutorial.name
            tutorials?.textDetails = detalheTutorial.details
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
