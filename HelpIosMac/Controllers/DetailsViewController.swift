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
        
        let barButton =  UIBarButtonItem(title: "Salvar", style: UIBarButtonItem.Style.done, target: self, action: #selector(realizaSalvamento))
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
        
    //action que envia string do video para proxima tela
    @IBAction func sendLinkVideo(_ sender: Any) {
        guard let linkYoutube = tutorialDetail?.linkVideo else { return }
        detailVideo.urlVideo = linkYoutube
    }
    
    func recuperaTutorial()->Tutorial?{
        
        guard let titulo = titleTextLabel?.text else { return nil }
        guard let texto = descriptionTextView?.text else { return nil }
        guard let pathArrayImage = tutorialDetail?.imagesUrl else { return nil }
        guard let id = tutorialDetail?.id else { return nil }
        
        let tutorial = Tutorial(id: id, name: titulo, details: texto, imagesUrl: pathArrayImage, images: [])
     
        return tutorial
    }
    
    // MARK: - CoreData Save
    
    @objc func realizaSalvamento(){
        
        guard let tutorial = recuperaTutorial() else { return }
        TutorialDAO().saveTutorial(tutorialSave: tutorial)
        
        let alert = UIAlertController(title: "Tutorial", message: "Tutorial salvo com sucesso no dispositivo", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: nil)
            alert.addAction(ok)
            
        present(alert, animated: true)
    }
      
    //MARK: - Configurando CollectionView
    
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
