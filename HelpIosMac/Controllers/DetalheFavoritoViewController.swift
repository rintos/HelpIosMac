//
//  DetalheFavoritoViewController.swift
//  HelpIosMac
//
//  Created by Victor on 13/09/2019.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class DetalheFavoritoViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var tituloLabel:UILabel!
    @IBOutlet weak var textoTextView:UITextView!
    @IBOutlet weak var editarTextView:UITextView!
    @IBOutlet weak var tutorialScroll:UIScrollView!
    
    
    
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
        
        
        //configurando view com teclado
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //ao clicar esconde teclado
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        //ao clicar esconde teclado
        view.addGestureRecognizer(tap)
        
    }
    
    //ao clicar esconde teclado
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    //funcao view teclado
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    //funcao view teclado
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
        
    func setupSubirCodigo(){
        
        
        
        let barButton =  UIBarButtonItem(title: "Update", style: UIBarButtonItem.Style.done, target: self, action: #selector(salvarTurialGravado))
        navigationItem.rightBarButtonItem = barButton
        
        if let tutorialFavorito = tutorial{
            self.tituloLabel.text = tutorialFavorito.name
            self.textoTextView.text = tutorialFavorito.textDetails
            self.editarTextView.text = tutorialFavorito.makeTutorial
            print("Caminho Imagem do Favorito armazenado\(String(describing: tutorialFavorito.imagesUrl))")
        
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
        guard let arrayImages = tutorial?.imagesUrl else { return 0 }
        let favoriteImages = arrayImages as! Array<String>
        
        return favoriteImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "images", for: indexPath) as! DetalhesCollectionViewCell
        guard let arrayImages = tutorial?.imagesUrl else { return cell }
        let favoriteImages = arrayImages as! Array<String>
        let pathImage = favoriteImages[indexPath.row]
        
        cell.imagensTutorial.image = UIImage(named: pathImage)
        
        return cell
    }
    

}
