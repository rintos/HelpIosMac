//
//  DetailsViewController.swift
//  HelpIosMac
//
//  Created by Victor on 28/08/2019.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import SDWebImage

class DetailsViewController: UIViewController,UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate {
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    //MARK: - Variaveis
    //Variaveis que recebem dados da ViewController
    var listImages = TutorialDAO().returnListImages()
    var tutorialDetail: Tutorial? // recebe o tutorial selecionado da viewConroller
    var tutorialsDetails: Tutorials? // segundo que recebe o tutorial
        
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
        
        print("Contagem de imagens passada entre telas: \(tutorialDetail?.imgData.count as Any)")
        
        print("Dados da imagem \(tutorialDetail?.imgData as Any)")
                        
    }
    
    override func viewDidAppear(_ animated: Bool) {
      //  verifica()
    }
    
    //MARK: - Metodos
    
    func verifica(){
        
        var verificaImagens: Array<UIImage> = []
        guard let namesList = tutorialDetail?.imagesUrl else { return }

        for names in namesList{
            guard let image = ImageController().fetchImage(imageName: names) else {return}
            verificaImagens.append(image)
        }
        
        let verifica = namesList as! Array<String>
        
        if verificaImagens.count > 0 {
            for name in namesList {
                ImageController().deleteImage(imageName: name)
                print("Deletado imagem encontrada")
            }
        }
        
        print("Tem Dados persistindo??\(verificaImagens)")
    }
    
    func deleteImagesShare(_ namesOfImages: Array<String>){
        
        for names in namesOfImages {
            ImageController().deleteImage(imageName: names)
            print("imagem deletada\(names)")
        }
        
    }
    
    
    func setupDadosView(){
        guard let detalheTutorial = tutorialDetail else { return }
        self.titleTextLabel.text = detalheTutorial.name
        self.descriptionTextView.text = detalheTutorial.details
    }
    
    //retorna array de lista de imagens para compartilhar
//    func extraiImagens() -> Array<UIImage>{
//
//        var imagemArray:Array<UIImage> = []
//
//        if let imagens = tutorialDetail?.imagesUrl{
//
//            for img in imagens{
//                imagemArray.append((UIImage(named: img))!)
//            }
//        }
//
//        return imagemArray
//    }
    
    //action que envia string do video para proxima tela
    @IBAction func sendLinkVideo(_ sender: Any) {
        guard let linkYoutube = tutorialDetail?.linkVideo else { return }
        detailVideo.urlVideo = linkYoutube
    }
    
    //funcao para compartilhar conteudos

    @IBAction func shareContent(_ sender: Any) {
                
       // let imagensLista = extraiImagens()
        var imagesArray: Array<UIImage> = []

        
        guard let namesList = tutorialDetail?.imagesUrl else { return }
        
        FireBase().getImageArray(namesList) { (images,name) in
            ImageController().saveImageForShare(image: images,imageName: name)
        }
        
        for names in namesList{
            guard let image = ImageController().fetchImage(imageName: names) else {return}
            imagesArray.append(image)
        }
        
        let activityController = UIActivityViewController(activityItems: imagesArray as [Any], applicationActivities: nil)
                            
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
            self.deleteImagesShare(namesList)
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
                    let tutorial = Tutorial(name: titulo, details: texto, imagesUrl: pathArrayImage, images: [])
                    //  print("Sanvando os dados titulo: \(tutorial.name) texto: \(tutorial.details)")
                    return tutorial
                }
            }
        }
        return nil
    }
        
    // MARK: - CoreData Save
    
    @objc func saveTutorial(){
                
        guard let detalheTutorial = tutorialDetail else { return }
        
        if tutorials == nil{
            tutorials = Tutorials(context: contexo)
        }

        if let tutorialFavorito = recuperaTutorial(){

            tutorials?.name = detalheTutorial.name
            tutorials?.textDetails = detalheTutorial.details
            tutorials?.imagesUrl = tutorialFavorito.imagesUrl as NSObject
            tutorials?.imageName = "temp"

            for nameOfImages in detalheTutorial.imagesUrl {
                FireBase().getImage(nameOfImages) { (imageData) in
                    ImageController().saveImage(image: imageData, imageName: nameOfImages)
                }
            }
            do{
                try self.contexo.save()
                let alert = UIAlertController(title: "Tutorial", message: "Tutorial salvo com sucesso no dispositivo", preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: nil)
                alert.addAction(ok)
                
                present(alert, animated: true)
//                if let navigation = self.navigationController{
//                    navigation.popViewController(animated: true)
//                    }
                } catch {
                    print(error.localizedDescription)
                }
          }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let images = tutorialDetail?.imagesUrl.count else { return 0 }
        return images
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageHome", for: indexPath) as! CollectionViewCell
        
        guard let namesOfImage = tutorialDetail?.imagesUrl[indexPath.row] else { return cell }
        
        cell.configCell(namesOfImage)
        
        return cell
    }
    
    
    

}
